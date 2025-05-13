import AVFoundation

class VideoSeekRequest: Request {
    override public func run() {
        let position: Int! = decodeData()
        
        let edge = getComponentEdge()!
        
        let videoEdge = edge.children[0]
        
        let element = videoEdge.element as! VideoElement
        
        let seconds = Double(position) / 1000
    
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        
        element.player?.seek(to: time)
        
        end()
    }
}
