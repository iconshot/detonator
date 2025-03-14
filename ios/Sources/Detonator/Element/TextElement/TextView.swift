import UIKit

public class TextView: UILabel {
    override public func drawText(in rect: CGRect) {
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
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
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
        
        if size.width != .greatestFiniteMagnitude {
            if let text = text {
                let lines = text.components(separatedBy: "\n")
                
                var maxReached = false

                for line in lines {
                    let lineSize = (line as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
                                        
                    if lineSize.width >= inputWidth {
                        maxReached = true
                        
                        break
                    }
                }
                
                if maxReached {
                    outputWidth = size.width
                }
            }
        }
        
        let outputSize = CGSize(width: outputWidth, height: outputHeight)
        
        return outputSize
    }
}
