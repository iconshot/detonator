import UIKit

private var isViewGroupKey: UInt8 = 0
private var layoutParamsKey: UInt8 = 0

extension UIView {
    var isViewGroup: Bool {
        get {
            let isViewGroup = objc_getAssociatedObject(self, &isViewGroupKey) as? Bool
            
            return isViewGroup ?? false
        }
        set {
            objc_setAssociatedObject(self, &isViewGroupKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
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
    
    @objc func measure(specWidth: CGFloat, specHeight: CGFloat, specWidthMode: Int, specHeightMode: Int) {
        var constraintWidth = CGFloat.greatestFiniteMagnitude
        var constraintHeight = CGFloat.greatestFiniteMagnitude
        
        switch specWidthMode {
        case MeasureSpec.EXACTLY:
            constraintWidth = specWidth
            
            break
            
        case MeasureSpec.AT_MOST:
            constraintWidth = specWidth
            
            break
            
        default:
            break
        }
        
        switch specHeightMode {
        case MeasureSpec.EXACTLY:
            constraintHeight = specHeight
            
            break
            
        case MeasureSpec.AT_MOST:
            constraintHeight = specHeight
            
            break
            
        default:
            break
        }
        
        let constraintSize = CGSize(width: constraintWidth, height: constraintHeight)
        
        let fittingSize = sizeThatFits(constraintSize)
        
        let resolvedWidth = resolveSize(size: fittingSize.width, specSize: specWidth, specSizeMode: specWidthMode)
        let resolvedHeight = resolveSize(size: fittingSize.height, specSize: specHeight, specSizeMode: specHeightMode)
        
        frame.size.width = resolvedWidth
        frame.size.height = resolvedHeight
    }
    
    @objc func layout(x: CGFloat, y: CGFloat) {
        frame.origin.x = x
        frame.origin.y = y
    }
    
    func resolveSize(size: CGFloat, specSize: CGFloat, specSizeMode: Int) -> CGFloat {
        switch specSizeMode {
        case MeasureSpec.EXACTLY:
            return specSize
            
            break
            
        case MeasureSpec.AT_MOST:
            return min(size, specSize)
            
            break
            
        default:
            return size
            
            break
        }
    }
}
