import UIKit

public class InputView: UITextField {
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return getInsetRect(bounds)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return getInsetRect(bounds)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return getInsetRect(bounds)
    }
    
    public func getInsetRect(_ rect: CGRect) -> CGRect {
        let padding = layoutParams.padding
        
        let insets = UIEdgeInsets(
            top: CGFloat(padding.top),
            left: CGFloat(padding.left),
            bottom: CGFloat(padding.bottom),
            right: CGFloat(padding.right)
        )
        
        return rect.inset(by: insets)
    }
}
