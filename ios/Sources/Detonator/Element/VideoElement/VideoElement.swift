import UIKit
import AVKit
import AVFoundation

class VideoElement: Element {
    public var player: AVPlayer?
    
    private let playerLayer: AVPlayerLayer = AVPlayerLayer()
    
    private var timer: Timer?
    
    private var currentPosition: Int = 0
    
    override public func decodeAttributes(edge: Edge) -> VideoAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> VideoView {
        let view = VideoView()
        
        view.playerLayer = playerLayer
        
        startTrackingProgress()
        
        return view
    }
    
    override public func patchView() {
        let view = view as! VideoView
        
        let attributes = attributes as! VideoAttributes
        let currentAttributes = currentAttributes as! VideoAttributes?
        
        let url = attributes.url
        let currentUrl = currentAttributes?.url
        
        let patchUrlBool = forcePatch || url != currentUrl
        
        if patchUrlBool {
            patchUrl(url: url)
        }
        
        let muted = attributes.muted
        let currentMuted = currentAttributes?.muted
        
        let patchMutedBool = forcePatch || muted != currentMuted
        
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
        let view = view as! VideoView
        
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
            
            playerLayer.player = player
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(videoDidEnd),
                name: .AVPlayerItemDidPlayToEndTime,
                object: player?.currentItem
            )
        }
    }
    
    private func deinitPlayer() {
        let view = view as! VideoView
        
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        player?.pause()
        
        player = nil
        
        playerLayer.player = nil
    }
    
    override public func removeView() {
        deinitPlayer()
        
        timer?.invalidate()
    }
    
    override func patchObjectFit(objectFit: String?) {
        switch objectFit {
        case "cover":
            playerLayer.videoGravity = .resizeAspectFill
            
            break
            
        case "contain":
            playerLayer.videoGravity = .resizeAspect
            
            break
            
        case "fill":
            playerLayer.videoGravity = .resize
            
            break
            
        default:
            playerLayer.videoGravity = .resizeAspectFill
            
            break
        }
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
    
    @objc func videoDidEnd() {
        detonator.emitHandler(name: "onEnd", edgeId: edge.id)
    }
    
    struct OnProgressData: Encodable {
        let position: Int
    }
    
    class VideoAttributes: Attributes {
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
