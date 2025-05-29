import UIKit

class FullScreenViewController: UIViewController {
    private var previousSize: CGSize = .zero
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func loadView() {
        view = ViewLayout()
    }
    
    override func viewWillLayoutSubviews() {
        let view = view as! ViewLayout
        
        let currentSize = view.frame.size
        
        if currentSize != previousSize {
            previousSize = currentSize
            
            view.performLayout()
        }
    }
}
