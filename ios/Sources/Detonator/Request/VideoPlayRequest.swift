class VideoPlayRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let videoEdge = edge.children[0]
        
        let element = videoEdge.element as! VideoElement
        
        element.player?.play()
        
        end()
    }
}
