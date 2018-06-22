//
//  VLDiscreteTimeDynamicSimulation.swift
//  VLModelKitCore
//
//  Created by Jeffrey Varner on 6/21/18.
//  Copyright © 2018 Varnerlab. All rights reserved.
//

import Foundation


public class VLDiscreteTimeDynamicSimulation:VLBaseSimulation {
    
    // setup the delegate -
    var delegate:VLSimulationDelegate?
    
    override public func solve(completion: @escaping Handler<VLMatrix<Float>>) {
    
        do {
            
            // do we have a delegate?
            if let delegate = delegate, let initial_condition = myModel.state {
                
                // what is my initial state?
                var current_state_array = initial_condition
                
                // number of states?
                let number_of_rows = current_state_array.count
                
                // initialize the state archive -
                var state_archive = VLMatrix<Float>.zeros(rows: number_of_rows, columns: 0)
                
                // update the state archive w/the initial conditions -
                state_archive = try (state_archive |= initial_condition).resolve()
                
                // get the simulation duration -
                let duration = delegate.range(simulation: self)
                
                // create a time array from the duration struct -
                var time_archive = [Float]()
                let start_time = duration.start
                let stop_time = duration.stop
                let step_size = duration.stepSize
                
                // add the start point to the time array -
                time_archive.append(start_time)
                
                // main loop -
                var current_time = start_time
                while (current_time<=stop_time) {
                    
                    // try to evaluate the model -
                    let model_result = try myModel.evaluate(state: current_state_array)
                    
                    // switch on the model result -
                    switch model_result {
                    case .success(let new_state_array):
                        
                        // update the state array -
                        current_state_array = new_state_array
                        
                        // update the time -
                        current_time += step_size
                        
                        // capture the time -
                        time_archive.append(current_time)
                        
                        // update the state archive -
                        state_archive = try (state_archive |= new_state_array).resolve()
                        
                    case.failure(let error):
                        completion(VLModelKitResult.failure(error: error))
                    }
                }
                
                // build the archive -
                let simulation_archive = self.buildSimulationArchive(timeArray: time_archive, stateArchive: state_archive)
                
                // call the completion -
                completion(VLModelKitResult.success(simulation_archive))
            }
        }
        catch {
            completion(VLModelKitResult.failure(error: VLModelKitError.SimulationFailedError(mesage: "\(error)")))
        }
        
        
        // oops - no delegate, not much we can do.
        completion(VLModelKitResult.failure(error: VLModelKitError.SimulationFailedError(mesage: "Solve failed ...")))
    }
    
    // MARK: - private helper methods -
    private func buildSimulationArchive(timeArray:[Float],stateArchive:VLMatrix<Float>) -> VLMatrix<Float> {
        
        // ok, lets get the dimension -
        let number_of_time_points = timeArray.count
        let number_of_states:Int = stateArchive.number_of_rows
        
        // generate new array -
        var simulation_archive = VLMatrix<Float>.zeros(rows: (number_of_states + 1), columns: number_of_time_points)
        
        // the first row is the time -
        for col_index in 0..<number_of_time_points {
            simulation_archive[0,col_index] = timeArray[col_index]
        }
        
        // the remaning rows are the states -
        for row_index in 0..<number_of_states {
            for col_index in 0..<number_of_time_points {
                
                // get the state value -
                let state_value = stateArchive[row_index,col_index]
                
                // store -
                simulation_archive[row_index+1,col_index] = state_value
            }
        }
        
        // return -
        return simulation_archive
    }
}
