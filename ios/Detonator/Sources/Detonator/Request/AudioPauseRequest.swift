class AudioPauseRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let element = edge.children[0].element as! AudioElement
        
        do {
            try element.pause()
            
            end()
        } catch {
            self.error(error: error)
        }
    }
}
