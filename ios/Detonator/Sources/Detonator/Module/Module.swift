import Foundation

open class Module: NSObject {
    public let detonator: Detonator
    
    required public init(_ detonator: Detonator) {
        self.detonator = detonator
    }
    
    open func setUp() -> Void {
        preconditionFailure("This method must be overriden.")
    }
}
