//
//  VLVector.swift
//  VLModelKit
//
//  Created by Jeffrey Varner on 6/21/18.
//

import Foundation

public struct VLVector<Element:Numeric> {
    
    public let count:Int
    internal var buffer = [Element]()
}

extension VLVector where Element == Float  {
    
    public init(count: Int = 0, repeatedValue:Element) {
        
        self.count = count
        
        // initialize -
        for _ in 0..<count {
            
            // add value to array -
            self.buffer.append(repeatedValue)
        }
    }
    
    public static func zeros(count: Int) -> VLVector<Float> {
        return VLVector<Float>(count: count, repeatedValue: 0.0)
    }
    
    public static func build(fromBuffer buffer:[Float]) -> VLVector<Float> {
        
        // init w/zeros -
        let number_of_elements = buffer.count
        var vector = VLVector<Float>.zeros(count: number_of_elements)
        
        // fill -
        for index in 0..<number_of_elements {
            vector[index] = buffer[index]
        }
        
        // return -
        return vector
    }
}

// subscript extensions -
extension VLVector where Element == Float {
    
    public subscript(_ linear_index: Int) -> Element {
        get {
            return buffer[linear_index]
        }
        set {
            buffer[linear_index] = newValue
        }
    }
}

// math extension -
extension VLVector where Element == Float {
    
    public static func +(left:VLVector<Float>,right:VLVector<Float>) -> VLVector<Float> {
        
        // get the buffers -
        let number_of_elements = left.count
        let left_buffer = left.buffer
        let right_buffer = right.buffer
        
        // initialize -
        var return_array = VLVector<Float>.zeros(count: number_of_elements)
        for index in 0..<number_of_elements {
            return_array[index] = left_buffer[index]+right_buffer[index]
        }
        
        // return -
        return return_array
    }
    
    public static func .*(left:VLVector<Float>,right:VLVector<Float>) -> VLVector<Float> {
        
        // get the buffers -
        let number_of_elements = left.count
        let left_buffer = left.buffer
        let right_buffer = right.buffer
        
        // initialize -
        var return_array = VLVector<Float>.zeros(count: number_of_elements)
        for index in 0..<number_of_elements {
            return_array[index] = left_buffer[index]*right_buffer[index]
        }
        
        // return -
        return return_array
    }
    
    public static func |=(left:VLVector<Float>,right:VLVector<Float>) -> VLModelKitResult<VLVector<Float>> {
        
        // what is the total length?
        var tmp_array = [Float]()
        for index in 0..<left.count {
            tmp_array.append(left[index])
        }
        
        for index in 0..<right.count {
            tmp_array.append(right[index])
        }
        
        // build tmp vector -
        let tmp_vector = VLVector<Float>.build(fromBuffer: tmp_array)
        
        // wrap and return -
        return VLModelKitResult.success(tmp_vector)
    }
}
