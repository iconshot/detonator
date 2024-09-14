class Emitter {
    let detonator: Detonator
    
    init(_ detonator: Detonator) {
        self.detonator = detonator
    }
    
    func emit() {
        preconditionFailure("This method must be overridden.")
    }
}
