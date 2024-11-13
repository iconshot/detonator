import UIKit
import AVKit
import AVFoundation

public class VideoView: UIView {
    var timer: Timer?
    
    public enum ObjectFit {
        case cover, contain, fill
    }
    
    public var objectFit: ObjectFit = .cover {
        didSet {
            updatePlayerLayerGravity()
        }
    }
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
        
    private var currentPosition: Int = 0
    
    public var onProgressListener: ((_ position: Int) -> Void)?
    
    public var onEndListener: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTimer()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupTimer()
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            let time = self.player?.currentTime() ?? CMTime.zero
            
            let position = Int(CMTimeGetSeconds(time) * 1000)
            
            if position == self.currentPosition {
                return
            }
            
            self.currentPosition = position
            
            self.onProgressListener?(position)
        }
    }
    
    func setupPlayer(urlString: String?) {
        deinitPlayer()
        
        guard let urlString = urlString else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
            
            try audioSession.setActive(true)
        } catch {
            return
        }
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
                
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        guard let playerLayer = playerLayer else {
            return
        }
        
        updatePlayerLayerGravity()
        
        layer.addSublayer(playerLayer)
    }
    
    private func deinitPlayer() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        player?.pause()
        
        playerLayer?.removeFromSuperlayer()
        
        player = nil
        playerLayer = nil
    }
    
    private func updatePlayerLayerGravity() {
        guard let playerLayer = playerLayer else {
            return
        }
        
        switch objectFit {
        case .cover:
            playerLayer.videoGravity = .resizeAspectFill

            break
            
        case .contain:
            playerLayer.videoGravity = .resizeAspect
            
            break
            
        case .fill:
            playerLayer.videoGravity = .resize
            
            break
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func seek(to position: Int) {
        let seconds = Double(position) / 1000
    
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
    
        player?.seek(to: time)
    }
    
    @objc func videoDidEnd() {
        onEndListener?()
    }
    
    override public func layoutSubviews() {
        playerLayer?.frame = bounds
    }
    
    public func remove() {
        timer?.invalidate()
        
        deinitPlayer()
    }
}
