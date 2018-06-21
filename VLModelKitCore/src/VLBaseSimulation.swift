//
//  VLBaseSimulation.swift
//  VLModelKitCore
//
//  Created by Jeffrey Varner on 6/21/18.
//  Copyright © 2018 Varnerlab. All rights reserved.
//

import Foundation

public class VLBaseSimulation {
    
    // iVars -
    var myModel:VLBaseModel
    
    // inits -
    public init(model:VLBaseModel) {
        self.myModel = model
    }
    
    public func solve(completion:@escaping Handler<VLMatrix<Float>>) throws -> Void {
    }
}
