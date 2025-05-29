import UIKit

class Target {
    public final let view: UIView
    public var index: Int
    
    init(view: UIView, index: Int) {
        self.view = view
        self.index = index
    }
    
    public func insert(child: UIView) {
        if child == FullScreenModule.view {
            return
        }
        
        let currentChild = index < view.subviews.count
            ? view.subviews[index]
            : nil
        
        if currentChild != nil {
            if child != currentChild {
                view.insertSubview(child, at: index)
            }
        } else {
            view.addSubview(child)
        }
        
        index += 1
    }
    
    public func remove(child: UIView) {
        child.removeFromSuperview()
    }
}
