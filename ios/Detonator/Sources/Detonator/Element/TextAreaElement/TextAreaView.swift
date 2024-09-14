import UIKit

class TextAreaView: UITextView {
    var onHeightChange: (() -> Void)?
    
    override var text: String! {
        didSet {
            onHeightChange?()
        }
    }
    
    override var contentSize: CGSize {
        didSet {
            onHeightChange?()
        }
    }
}
