import UIKit
import AVKit

public class VideoView: UIView {
    public var playerLayer: AVPlayerLayer? {
        didSet {
            if let playerLayer = playerLayer {
                layer.addSublayer(playerLayer)
            }
        }
    }
    
    override public func layoutSubviews() {
        playerLayer?.frame = bounds
    }
}
