//
//  VLBaseModel.swift
//  VLModelKit
//
//  Created by Jeffrey Varner on 6/21/18.
//

import Foundation

public protocol VLModelDelegate {
    
    func initial(model:VLBaseModel) -> VLModelKitResult<VLVector<Float>>
    func generate(parameters:VLModelParameters,array:VLSystemArrayType) -> VLModelKitResult<VLMatrix<Float>>
}

/// Base class for all models - extended by specific models
public class VLBaseModel {
    
    // iVars -
    var myModelParameters:VLModelParameters

    var state:VLVector<Float>?
    
    // default init:
    public init(parameters:VLModelParameters) {
        self.myModelParameters = parameters
    }
    
    // override point -
    public func evaluate(state:VLVector<Float>) throws -> VLModelKitResult<VLVector<Float>> {
        return VLModelKitResult.failure(error: VLModelKitError.ModelNotImplementError(message: "Calling the evaluate() method in VLBaseModel"))
    }
}
