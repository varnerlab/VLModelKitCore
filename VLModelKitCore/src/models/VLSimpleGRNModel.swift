//
//  VLSimpleGRNModel.swift
//  VLModelKitCore
//
//  Created by Jeffrey Varner on 6/21/18.
//  Copyright © 2018 Varnerlab. All rights reserved.
//

import Foundation

public protocol VLGeneExpressionModelDelegate:VLModelDelegate {
    
    func transcription(time:Float,state:VLVector<Float>,parameters:VLModelParameters) -> VLModelKitResult<VLVector<Float>>
    func translation(time:Float,state:VLVector<Float>,parameters:VLModelParameters) -> VLModelKitResult<VLVector<Float>>
    func growth(time:Float, state:VLVector<Float>, parameters:VLModelParameters) -> VLModelKitResult<Float>
    func degradation(time:Float, state:VLVector<Float>, speciesType:VLSpeciesType, parameters:VLModelParameters) -> VLModelKitResult<VLVector<Float>>
    func control(time:Float, state:VLVector<Float>, controlType:VLControlType, parameters:VLModelParameters) -> VLModelKitResult<VLVector<Float>>
}

public class VLSimpleGRNModel:VLBaseModel {
    
    // iVars -
    var delegate:VLGeneExpressionModelDelegate?
    
    // system arrays -
    var AM:VLMatrix<Float>?
    var BM:VLMatrix<Float>?
    var CM:VLMatrix<Float>?
    
    // override -
    public override func evaluate(state:VLVector<Float>) throws -> VLModelKitResult<VLVector<Float>> {
        
        // ok, evaluate the kinetics -
        if let AM = AM, let BM = BM {
            
            // calculate the rates -
            let kinetic_array = try self.kinetic(time:0.0,state: state, parameters: myModelParameters).resolve()
            
            // evaluate the RHS of the model -
            let term_1:VLVector<Float> = try (AM*state).resolve()
            let term_2:VLVector<Float> = try (BM*kinetic_array).resolve()
            let tmp_array = term_1 + term_2
           
            // call the completion handler -
            return VLModelKitResult.success(tmp_array)
        }
        
        return VLModelKitResult.failure(error: VLModelKitError.SimulationFailedError(mesage: "Model evaluation failed"))
    }
    
    // MARK: - private helper method -
    private func kinetic(time:Float,state:VLVector<Float>,parameters:VLModelParameters) throws -> VLModelKitResult<VLVector<Float>> {
        
        // do we have a delegate?
        guard let local_delegate = delegate else {
            return VLModelKitResult.failure(error: VLModelKitError.SimulationFailedError(mesage: "Missing delegate?"))
        }
        
        // ok, so we have a delegate, calculate the transcription and translation rates -
        let transcription_rate_array = try local_delegate.transcription(time: time, state: state, parameters: myModelParameters).resolve()
        let translation_rate_array = try local_delegate.translation(time: time, state: state, parameters: myModelParameters).resolve()
        let transcription_control_array = try local_delegate.control(time: time, state: state, controlType: VLControlType.transcription, parameters: myModelParameters).resolve()
        let translation_control_array = try local_delegate.control(time: time, state: state, controlType: VLControlType.translation, parameters: myModelParameters).resolve()
        
        // build the kinetics and control array -
        let raw_kinetics_array = try (transcription_rate_array |= translation_rate_array).resolve()
        let control_array = try (transcription_control_array |= translation_control_array).resolve()
        
        // do the calculation -
        let tmp_array = raw_kinetics_array .* control_array
        return VLModelKitResult.success(tmp_array)
    }
}

// Factory extension
extension VLSimpleGRNModel {
    
    public static func buildModel(withParameters parameters:VLModelParameters, andDelegate delegate:VLGeneExpressionModelDelegate) throws -> VLSimpleGRNModel {
        
        // build a model instance, and set the delegate -
        let myModel = VLSimpleGRNModel(parameters: parameters)
        myModel.delegate = delegate
        
        // call the delegate to generate the system arrays -
        myModel.AM = try delegate.generate(parameters: parameters, array: VLSystemArrayType.AM).resolve()
        myModel.BM = try delegate.generate(parameters: parameters, array: VLSystemArrayType.BM).resolve()
        myModel.CM = try delegate.generate(parameters: parameters, array: VLSystemArrayType.CM).resolve()
        
        // initialize the system w/the initial state -
        myModel.state = try delegate.initial(model: myModel).resolve()
        
        // return -
        return myModel
    }
}
