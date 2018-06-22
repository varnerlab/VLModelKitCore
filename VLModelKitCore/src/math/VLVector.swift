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
    
}
