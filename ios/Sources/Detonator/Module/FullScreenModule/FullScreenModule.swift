import UIKit

class FullScreenModule: Module {
    override func register() -> Void {
        detonator.addRequestClass(key: "com.iconshot.detonator.fullscreen/open", requestClass: FullScreenOpenRequest.self)
        detonator.addRequestClass(key: "com.iconshot.detonator.fullscreen/close", requestClass: FullScreenCloseRequest.self)
    }
    
    static var parent: UIView? = nil
    static var view: ViewLayout? = nil
    static var index: Int? = nil
    static var layoutParams: LayoutParams? = nil
    static var fullScreenViewController: FullScreenViewController? = nil
}
