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

public protocol VLGeneExpressionModelDelegate:VLModelDelegate {
    
    func transcription(time:Float,state:VLVector<Float>,parameters:VLModelParameters) -> VLModelKitResult<VLVector<Float>>
    func translation(time:Float,state:VLVector<Float>,parameters:VLModelParameters) -> VLModelKitResult<VLVector<Float>>
    func growth(time:Float, state:VLVector<Float>, parameters:VLModelParameters) -> VLModelKitResult<Float>
    func degradation(time:Float, state:VLVector<Float>, speciesType:VLSpeciesType, parameters:VLModelParameters) -> VLModelKitResult<VLVector<Float>>
    func control(time:Float, state:VLVector<Float>, controlType:VLControlType, parameters:VLModelParameters) -> VLModelKitResult<VLVector<Float>>
}


/// Base class for all models - extended by specific models
public class VLBaseModel {
    
    // iVars -
    var myModelParameters:VLModelParameters
    
    // default init:
    public init(parameters:VLModelParameters) {
        self.myModelParameters = parameters
    }
    
    // override point -
    public func evaluate(completion: @escaping Handler<VLVector<Float>>) throws -> Void {
    }
}
