import UIKit
import AVKit
import AVFoundation

public class VideoView: UIView {
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
        
        guard let playerLayer = playerLayer else {
            return
        }
        
        updatePlayerLayerGravity()
        
        layer.addSublayer(playerLayer)
    }
    
    private func deinitPlayer() {
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
    
    func seek(to ms: Int) {
        let seconds = Double(ms) / 1000
    
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
    
        player?.seek(to: time)
    }
    
    override public func layoutSubviews() {
        playerLayer?.frame = bounds
    }
    
    public override func removeFromSuperview() {
        deinitPlayer()
        
        super.removeFromSuperview()
    }
}
