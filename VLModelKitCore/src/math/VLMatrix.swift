//
//  VLMatrix.swift
//  VLModelKit
//
//  Created by Jeffrey Varner on 6/21/18.
//

import Foundation

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
        return VLModelKitResult.success(VLVector<Float>.zeros(count: 0))
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
