import UIKit

class InputView: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return getInsetRect(bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return getInsetRect(bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return getInsetRect(bounds)
    }
    
    func getInsetRect(_ rect: CGRect) -> CGRect {
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
