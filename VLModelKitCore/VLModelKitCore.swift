import Foundation

/// Typealias: Define callback for the model simulation
public typealias Handler<Value> = (VLModelKitResult<Value>) -> Void

/// Error type: SimulationFailedError - general error indicating something happend
public enum VLModelKitError:Error {
    case SimulationFailedError(mesage:String)
    case ModelNotImplementError(message:String)
    case DimensionMismatchError(message:String)
}

/// Species type: Atomic types of species in the model -
public enum VLSpeciesType {
    
    case metabolite
    case protein
    case mRNA
}

/// System array type: Types of system arrays -
public enum VLSystemArrayType {
    case AM
    case BM
    case CM
    case DM
}

/// Control type: Types of control functions -
public enum VLControlType {
    
    case transcription
    case translation
    case activity
}

/// Window type: Encodes the time window that we want to look at -
public struct VLSimulationRange {
    
    public var start:Float
    public var stop:Float
    public var stepSize:Float
    
    public init(start:Float = 0.0, stop:Float = 1.0, stepSize:Float = 0.1) {
        self.start = start
        self.stop = stop
        self.stepSize = stepSize
    }
}

/// Result type: Holds simulation data, or an error depending upon if the simulation failed with some error
public enum VLModelKitResult<Value> {
    case success(Value)
    case failure(error:VLModelKitError)
}

extension VLModelKitResult {
    
    func resolve() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

/// operators -
infix operator .*: MultiplicationPrecedence
infix operator |=: AssignmentPrecedence
