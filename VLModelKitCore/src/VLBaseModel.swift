//
//  VLBaseModel.swift
//  VLModelKit
//
//  Created by Jeffrey Varner on 6/21/18.
//

import Foundation

public protocol VLModelDelegate {
    
    func time(model:VLBaseModel) -> VLSimulationTimeWindow
    func initial(model:VLBaseModel) -> VLVector<Float>
}


/// Base class for all models - extended by specific models
public class VLBaseModel {
    
    // iVars -
    private var myModelParameters:VLModelParameters
    var delegate:VLModelDelegate?
    
    // default init:
    public init(parameters:VLModelParameters) {
        self.myModelParameters = parameters
    }
    
    /// Override me -
    public func solve(results: @escaping Handler) -> Void {
    }
}
