import UIKit

public class TextAreaView: UITextView {
    var onHeightChange: (() -> Void)?
    
    override public var text: String! {
        didSet {
            onHeightChange?()
        }
    }
    
    override public var contentSize: CGSize {
        didSet {
            onHeightChange?()
        }
    }
}
