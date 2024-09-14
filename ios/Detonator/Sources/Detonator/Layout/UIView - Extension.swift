import UIKit

private var layoutParamsKey: UInt8 = 0

extension UIView {
    var layoutParams: LayoutParams {
        get {
            var layoutParams = objc_getAssociatedObject(self, &layoutParamsKey) as? LayoutParams
            
            if layoutParams == nil {
                layoutParams = LayoutParams()
                
                objc_setAssociatedObject(self, &layoutParamsKey, layoutParams, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            return layoutParams!
        }
        set {
            objc_setAssociatedObject(self, &layoutParamsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
