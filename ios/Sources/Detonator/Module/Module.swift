open class Module {
    let detonator: Detonator
    
    required public init(_ detonator: Detonator) {
        self.detonator = detonator
    }
    
    open func register() -> Void {
        preconditionFailure("This method must be overriden.")
    }
}
