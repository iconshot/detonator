class VideoPlayRequest: Request {
    override public func run() {
        let edge = getComponentEdge()!
        
        let videoEdge = edge.children[0]
        
        let videoView = videoEdge.element!.view as! VideoView
        
        videoView.play()
        
        end()
    }
}
