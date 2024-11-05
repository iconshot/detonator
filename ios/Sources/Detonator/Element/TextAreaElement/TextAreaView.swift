import Foundation
import UIKit

public class TextAreaView: UITextView {
    var placeholder: TextView!
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupPlaceholder()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        placeholder = TextView()
        
        placeholder.numberOfLines = 0
        placeholder.isUserInteractionEnabled = false
        
        addSubview(placeholder)
    }
    
    public override func measure(specWidth: CGFloat, specHeight: CGFloat, specWidthMode: Int, specHeightMode: Int) {
        super.measure(
            specWidth: specWidth,
            specHeight: specHeight,
            specWidthMode: specWidthMode,
            specHeightMode: specHeightMode
        )
        
        placeholder.measure(
            specWidth: specWidth,
            specHeight: specHeight,
            specWidthMode: specWidthMode,
            specHeightMode: specHeightMode
        )
        
        frame.size.width = max(frame.size.width, placeholder.frame.size.width)
        frame.size.height = max(frame.size.height, placeholder.frame.size.height)
    }
    
    public override func layout(x: CGFloat, y: CGFloat) {
        frame.origin.x = x
        frame.origin.y = y
        
        placeholder.layout(x: 0, y: 0)
        
        placeholder.isHidden = !text.isEmpty
    }
    
    public override func layoutSubviews() {}
}
