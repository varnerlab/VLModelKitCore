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
    
    public static func *(left:VLMatrix<Float>,right:VLVector<Float>) -> VLVector<Float> {
        return VLVector<Float>.zeros(count: 0)
    }
}
