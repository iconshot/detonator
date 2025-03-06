import UIKit
import AVKit
import AVFoundation

class AudioElement: Element {
    public var player: AVPlayer?
    
    private var timer: Timer?
    
    private var currentPosition: Int = 0
    
    override public func decodeAttributes(edge: Edge) -> AudioAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> UIView {
        let view = UIView()
        
        startTrackingProgress()
        
        return view
    }
    
    override public func patchView() {
        let attributes = attributes as! AudioAttributes
        let prevAttributes = prevAttributes as! AudioAttributes?
        
        let url = attributes.url
        let prevUrl = prevAttributes?.url
        
        let patchUrlBool = forcePatch || url != prevUrl
        
        if patchUrlBool {
            patchUrl(url: url)
        }
        
        let muted = attributes.muted
        let prevMuted = prevAttributes?.muted
        
        let patchMutedBool = forcePatch || muted != prevMuted
        
        if patchMutedBool || patchUrlBool {
            if let player = player {
                if muted == true {
                    player.volume = 0
                } else {
                    player.volume = 1
                }
            }
        }
    }
    
    private func patchUrl(url: String?) {
        deinitPlayer()
        
        if let url = url {
            guard let playerUrl = URL(string: url) else {
                return
            }
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
                
                try audioSession.setActive(true)
            } catch {
                return
            }
            
            player = AVPlayer(url: playerUrl)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidEnd),
                name: .AVPlayerItemDidPlayToEndTime,
                object: player?.currentItem
            )
        }
    }
    
    private func deinitPlayer() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        player?.pause()
        
        player = nil
    }
    
    override public func removeView() {
        deinitPlayer()
        
        timer?.invalidate()
    }
    
    private func startTrackingProgress() {
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 30, repeats: true) { timer in
            let time = self.player?.currentTime() ?? CMTime.zero
            
            let position = Int(CMTimeGetSeconds(time) * 1000)
            
            if position == self.currentPosition {
                return
            }
            
            self.currentPosition = position
            
            let data = OnProgressData(position: position)
            
            self.detonator.emitHandler(name: "onProgress", edgeId: self.edge.id, data: data)
        }
    }
    
    @objc func playerDidEnd() {
        detonator.emitHandler(name: "onEnd", edgeId: edge.id)
    }
    
    struct OnProgressData: Encodable {
        let position: Int
    }
    
    class AudioAttributes: Attributes {
        var url: String?
        var muted: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            url = try container.decodeIfPresent(String.self, forKey: .url)
            muted = try container.decodeIfPresent(Bool.self, forKey: .muted)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case url
            case muted
        }
    }
}
