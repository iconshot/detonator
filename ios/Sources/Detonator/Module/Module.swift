open class Module {
    let detonator: Detonator
    
    required public init(_ detonator: Detonator) {
        self.detonator = detonator
    }
    
    func register() {
        preconditionFailure("This method must be overriden.")
    }
}
