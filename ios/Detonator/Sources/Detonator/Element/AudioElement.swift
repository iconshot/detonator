import UIKit
import AVKit
import AVFoundation

class AudioElement: Element {
    private var player: AVPlayer?
    
    private var timer: Timer?
    
    private var currentPosition: Int = 0
    
    override public func decodeAttributes() -> AudioAttributes? {
        return super.decodeAttributes()
    }
    
    override public func createView() -> UIView {
        let view = UIView()
        
        startTrackingProgress()
        
        return view
    }
    
    override public func patchView() {
        let attributes = attributes as! AudioAttributes
        let prevAttributes = prevAttributes as! AudioAttributes?
        
        let source = attributes.source
        let prevSource = prevAttributes?.source
        
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
    
    override func patchDisplay(display: String?) {
        super.patchDisplay(display: "none")
    }
    
    private func patchSource(source: String?) {
        deinitPlayer()
        
        guard let source = source else {
            return
        }
        
        guard let playerURL = URL(string: source) else {
            return
        }
        
        self.player = AVPlayer(url: playerURL)
        
        self.initPlayer()
    }
    
    private func initPlayer() -> Void {
        let audioSession = AVAudioSession.sharedInstance()
        
        try? audioSession.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
        try? audioSession.setActive(true)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        emitHandler(name: "onReady")
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
    
    public func play() throws -> Void {
        guard let player = player else {
            let error = NSError(domain: "com.iconshot.detonator.audio", code: -1, userInfo: [NSLocalizedDescriptionKey: "No player available."])
            
            throw error
        }
        
        player.play()
    }
    
    public func pause() throws -> Void {
        guard let player = player else {
            let error = NSError(domain: "com.iconshot.detonator.audio", code: -1, userInfo: [NSLocalizedDescriptionKey: "No player available."])
            
            throw error
        }
        
        player.pause()
    }
    
    public func seek(position: Int) throws -> Void {
        guard let player = player else {
            let error = NSError(domain: "com.iconshot.detonator.audio", code: -1, userInfo: [NSLocalizedDescriptionKey: "No player available."])
            
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
    
    class AudioAttributes: Attributes {
        var source: String?
        var muted: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            source = try container.decodeIfPresent(String.self, forKey: .source)
            muted = try container.decodeIfPresent(Bool.self, forKey: .muted)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case source
            case muted
        }
    }
}
