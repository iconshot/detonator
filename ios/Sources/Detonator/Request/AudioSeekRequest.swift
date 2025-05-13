import AVFoundation

class AudioSeekRequest: Request {
    override public func run() {
        let position: Int! = decodeData()
        
        let edge = getComponentEdge()!
        
        let audioEdge = edge.children[0]
        
        let element = audioEdge.element as! AudioElement
        
        let seconds = Double(position) / 1000
    
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        
        element.player?.seek(to: time)
        
        end()
    }
}
