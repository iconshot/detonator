class VideoSeekRequest: Request {
    override public func run() {
        let ms: Int = decode()!
        
        let edge = getComponentEdge()!
        
        let videoEdge = edge.children[0]
        
        let videoView = videoEdge.element!.view as! VideoView
        
        videoView.seek(to: ms)
        
        end()
    }
}
