class AudioPlayRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let audioEdge = edge.children[0]
        
        let element = audioEdge.element as! AudioElement
        
        element.player?.play()
        
        end()
    }
}
