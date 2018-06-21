import Foundation

/// Typealias: Define callback for the model simulation
typealias Handler = (VLModelKitResult<VLMatrix<Float>>) -> Void

/// Result type: Holds simulation data, or an error depending upon if the simulation failed with some error
public enum VLModelKitResult<Value> {
    case Result(Value)
    case Error(error:VLModelKitError)
}

/// Error type: SimulationFailedError - general error indicating something happend
public enum VLModelKitError:Error {
    case SimulationFailedError(mesage:String)
}

/// Window type: Encodes the time window that we want to look at -
public struct VLSimulationTimeWindow {
    
    public var start:Float
    public var stop:Float
    public var stepSize:Float
    
    public init(start:Float = 0.0, stop:Float = 1.0, stepSize:Float = 0.1) {
        self.start = start
        self.stop = stop
        self.stepSize = stepSize
    }
}
