import UIKit
import AVKit
import AVFoundation
import Photos

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
        
        setRequestListener("com.iconshot.detonator.ui.video::play") { promise, value in
            guard let player = self.player else {
                promise.reject("No player available.")
                
                return
            }
            
            player.play()
            
            promise.resolve()
        }
        
        setRequestListener("com.iconshot.detonator.ui.video::pause") { promise, value in
            guard let player = self.player else {
                promise.reject("No player available.")
                
                return
            }
            
            player.pause()
            
            promise.resolve()
        }
        
        setRequestListener("com.iconshot.detonator.ui.video::seek") { promise, value in
            let position: Int = self.detonator.decode(value)!
            
            guard let player = self.player else {
                promise.reject("No player available.")
                
                return
            }
            
            let seconds = Double(position) / 1000
        
            let time = CMTime(seconds: seconds, preferredTimescale: 600)
            
            player.seek(to: time)
            
            promise.resolve()
        }
        
        return view
    }
    
    override public func patchView() {
        let attributes = attributes as! VideoAttributes
        let prevAttributes = prevAttributes as! VideoAttributes?
        
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
    
    private func patchSource(source: String?) {
        deinitPlayer()
        
        guard let source = source else {
            return
        }
        
        if source.starts(with: "content://") {
            let localIdentifier = source.replacingOccurrences(of: "content://", with: "")
            
            let result = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
            
            guard let asset = result.firstObject else {
                return
            }
            
            if asset.mediaType != .video {
                return
            }
            
            let manager = PHImageManager.default()

            let options = PHVideoRequestOptions()
            
            options.isNetworkAccessAllowed = true

            manager.requestAVAsset(forVideo: asset, options: options) { avAsset, audioMix, info in
                guard let avAsset = avAsset else {
                    return
                }
                
                let playerItem = AVPlayerItem(asset: avAsset)
                
                self.player = AVPlayer(playerItem: playerItem)
                
                self.initPlayer()
            }
            
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
        
        playerLayer.player = player
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        sendHandler(name: "onReady")
    }
    
    private func deinitPlayer() -> Void {
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
            
            self.sendHandler(name: "onProgress", data: data)
        }
    }
    
    @objc func playerDidEnd() {
        sendHandler(name: "onEnd")
    }
    
    struct OnProgressData: Encodable {
        let position: Int
    }
    
    class VideoAttributes: Attributes {
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
