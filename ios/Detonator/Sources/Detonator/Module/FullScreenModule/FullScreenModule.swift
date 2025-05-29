import UIKit

class FullScreenModule: Module {
    override func register() -> Void {
        detonator.setRequestClass("com.iconshot.detonator.fullscreen::open", FullScreenOpenRequest.self)
        detonator.setRequestClass("com.iconshot.detonator.fullscreen::close", FullScreenCloseRequest.self)
    }
    
    static var parent: UIView? = nil
    static var view: ViewLayout? = nil
    static var index: Int? = nil
    static var layoutParams: LayoutParams? = nil
    static var fullScreenViewController: FullScreenViewController? = nil
}
