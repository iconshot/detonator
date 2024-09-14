import UIKit

class TextView: UILabel {
    override func drawText(in rect: CGRect) {
        let padding = layoutParams.padding
        
        let insets = UIEdgeInsets(
            top: CGFloat(padding.top),
            left: CGFloat(padding.left),
            bottom: CGFloat(padding.bottom),
            right: CGFloat(padding.right)
        )
        
        let insetRect = rect.inset(by: insets)
    
        super.drawText(in: insetRect)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let padding = layoutParams.padding
        
        let paddingX = padding.left + padding.right
        let paddingY = padding.top + padding.bottom
        
        var inputWidth = size.width
        var inputHeight = size.height
        
        if size.width != .greatestFiniteMagnitude {
            inputWidth -= CGFloat(paddingX)
        }
        
        if size.height != .greatestFiniteMagnitude {
            inputHeight -= CGFloat(paddingY)
        }
        
        let inputSize = CGSize(width: inputWidth, height: inputHeight)
        
        let fittingSize = super.sizeThatFits(inputSize)
        
        var outputWidth = fittingSize.width + CGFloat(paddingX)
        var outputHeight = fittingSize.height + CGFloat(paddingY)
        
        if size.width != .greatestFiniteMagnitude {
            outputWidth = min(outputWidth, size.width)
        }
        
        if size.height != .greatestFiniteMagnitude {
            outputHeight = min(outputHeight, size.height)
        }
        
        let outputSize = CGSize(width: outputWidth, height: outputHeight)
        
        return outputSize
    }
}
