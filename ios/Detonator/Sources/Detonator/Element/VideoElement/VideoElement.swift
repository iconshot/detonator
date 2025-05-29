import UIKit
import AVKit
import AVFoundation

class VideoElement: Element {
    private var player: AVPlayer?
    
    private let playerLayer: AVPlayerLayer = AVPlayerLayer()
    
    private var timer: Timer?
    
    private var currentPosition: Int = 0
    
    override public func decodeAttributes() -> VideoAttributes? {
        return super.decodeAttributes()
    }
    
    override public func createView() -> VideoView {
        let view = VideoView()
        
        view.playerLayer = playerLayer
        
        startTrackingProgress()
        
        return view
    }
    
    override public func patchView() {
        let attributes = attributes as! VideoAttributes
        let prevAttributes = prevAttributes as! VideoAttributes?
        
        let source = attributes.url
        let prevSource = prevAttributes?.url
        
        let patchSourceBool = forcePatch || source != prevSource
        
        if patchSourceBool {
            patchSource(source: source)
        }
        
        let muted = attributes.muted
        let prevMuted = prevAttributes?.muted
        
        let patchMutedBool = forcePatch || muted != prevMuted
        
        if patchMutedBool || patchSourceBool {
            if let player = player {
                if muted == true {
                    player.volume = 0
                } else {
                    player.volume = 1
                }
            }
        }
    }
    
    private func patchSource(source: String?) {
        deinitPlayer()
        
        guard let source = source else {
            return
        }
        
        guard let playerURL = URL(string: source) else {
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
            
            try audioSession.setActive(true)
        } catch {
            return
        }
        
        player = AVPlayer(url: playerURL)
        
        playerLayer.player = player
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    private func deinitPlayer() {
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
    
    public func play() throws -> Void {
        guard let player = player else {
            let error = NSError(domain: "com.iconshot.detonator.video", code: -1, userInfo: [NSLocalizedDescriptionKey: "No player available."])
            
            throw error
        }
        
        player.play()
    }
    
    public func pause() throws -> Void {
        guard let player = player else {
            let error = NSError(domain: "com.iconshot.detonator.video", code: -1, userInfo: [NSLocalizedDescriptionKey: "No player available."])
            
            throw error
        }
        
        player.pause()
    }
    
    public func seek(position: Int) throws -> Void {
        guard let player = player else {
            let error = NSError(domain: "com.iconshot.detonator.video", code: -1, userInfo: [NSLocalizedDescriptionKey: "No player available."])
            
            throw error
        }
        
        let seconds = Double(position) / 1000
    
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        
        player.seek(to: time)
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
            
            self.emitHandler(name: "onProgress", data: data)
        }
    }
    
    @objc func playerDidEnd() {
        emitHandler(name: "onEnd")
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
