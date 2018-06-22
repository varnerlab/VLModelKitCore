//
//  VLMatrix.swift
//  VLModelKit
//
//  Created by Jeffrey Varner on 6/21/18.
//

import Foundation
import Accelerate

public struct VLMatrix<Element:Numeric> {
    
    public let number_of_rows:Int
    public let number_of_cols:Int
    internal var buffer = [Element]()
}

// factory extension -
extension VLMatrix {
    
    public init(rows: Int = 0, columns: Int = 0, repeatedValue:Element) {
        
        self.number_of_rows = rows
        self.number_of_cols = columns
        
        // initialize -
        for _ in 0..<rows {
            for _ in 0..<columns {
                
                // add value to array -
                self.buffer.append(repeatedValue)
            }
        }
    }
    
    public static func zeros(rows: Int, columns: Int) -> VLMatrix<Float> {
        return VLMatrix<Float>(rows: rows, columns: columns, repeatedValue: 0.0)
    }
}

extension VLMatrix where Element == Float {
    
    public subscript(_ row: Int, _ column: Int) -> Element {
        get {
            
            let linear_index = (self.number_of_cols)*row + column
            return buffer[linear_index]
        }
        set {
            
            let linear_index = (self.number_of_cols)*row + column
            buffer[linear_index] = newValue
        }
    }
}

// math extension -
extension VLMatrix where Element == Float {
    
    public static func *(left:VLMatrix<Float>,right:VLVector<Float>) -> VLModelKitResult<VLVector<Float>> {
        
        // do the dimensions match?
        guard left.number_of_cols == right.count else {
            
            return VLModelKitResult.failure(error: VLModelKitError.DimensionMismatchError(message: "ERROR: Trailing and leading dimensions must match for matrix vector multiplication operation"))
        }
        
        // get the buffers -
        let buffer_left = left.buffer
        let buffer_right = right.buffer
        
        // initialize the solution buffer -
        var solution_buffer = VLVector<Float>.zeros(count: left.number_of_rows)
        
        // setup the calculation -
        let M = Int32(left.number_of_rows)
        let N = Int32(left.number_of_cols)
        let stride:Int32 = 1
        cblas_sgemv(CblasRowMajor, CblasNoTrans,M, N, 1.0, buffer_left, N, buffer_right, stride, 0.0, &(solution_buffer.buffer), stride)
        
        // return the solution buffer -
        return VLModelKitResult.success(solution_buffer)
    }
    
    public static func *(left:VLMatrix<Float>,right:VLMatrix<Float>) -> VLModelKitResult<VLMatrix<Float>>  {
        
        // if the length of these arrays is not the same, then they can't be added -
        guard left.number_of_cols == right.number_of_rows else {
            return VLModelKitResult.failure(error: VLModelKitError.DimensionMismatchError(message: "ERROR: Trailing and leading dimensions must match for matrix vector multiplication operation"))
        }
        
        // TODO: Impl matrix multiplication
        // 1) get buffers -
        let buffer_left = left.buffer
        let buffer_right = right.buffer
        
        // 2) initialize final buffer -
        var CMatrix = VLMatrix<Float>(rows: left.number_of_rows, columns: right.number_of_cols, repeatedValue: 0.0)
        
        // 3) do the calculation -
        let M = Int32(left.number_of_rows)
        let N = Int32(right.number_of_cols)
        let K = Int32(left.number_of_cols)
        let LDA = K
        let LDB = N
        let LDC = M
        cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, 1.0,
                    buffer_left, LDA, buffer_right, LDB, 0.0, &(CMatrix.buffer), LDC)
        
        // 4)
        return VLModelKitResult.success(CMatrix)
    }
    
    public static func |=(left:VLMatrix<Float>,right:VLVector<Float>) -> VLModelKitResult<VLMatrix<Float>> {
        
        // get the dimension of the left matrix -
        let number_of_rows = left.number_of_rows
        let number_of_cols = left.number_of_cols
        
        // lets check - do we have the correct number of rows in the right vector -
        guard number_of_rows != right.count else {
            return VLModelKitResult.failure(error: VLModelKitError.DimensionMismatchError(message: "Vector cannot be appended to matrix - dimension mismatch."))
        }
        
        // initialize new array -
        var new_array = VLMatrix<Float>.zeros(rows: (number_of_rows), columns: (number_of_cols + 1))
        
        // copy the old array into the new_array -
        for row_index in 0..<number_of_rows {
            for col_index in 0..<number_of_cols {
                
                // get the old value -
                let old_value = left[row_index,col_index]
                
                // set -
                new_array[row_index,col_index] = old_value
            }
        }
        
        // lastly, copy the vector into the array -
        for row_index in 0..<number_of_rows {
            
            // get the new_value -
            let new_value = right[row_index]
            
            // set -
            new_array[row_index,number_of_cols] = new_value
        }
        
        // return -
        return VLModelKitResult.success(new_array)
    }
}
