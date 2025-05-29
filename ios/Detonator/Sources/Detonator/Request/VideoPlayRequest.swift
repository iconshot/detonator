class VideoPlayRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let element = edge.children[0].element as! VideoElement
        
        do {
            try element.play()
            
            end()
        } catch {
            self.error(error: error)
        }
    }
}
