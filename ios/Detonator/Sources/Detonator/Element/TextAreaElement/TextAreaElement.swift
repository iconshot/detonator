import UIKit

class TextAreaElement: Element, UIGestureRecognizerDelegate, UITextViewDelegate {
    override public func decodeAttributes(edge: Edge) -> TextAreaAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> TextAreaView {
        let view = TextAreaView()
        
        view.delegate = self
        
        tapGestureRecognizer.delegate = self
        
        view.isScrollEnabled = true
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = true
        
        view.textContainer.lineBreakMode = .byWordWrapping
        view.textContainer.maximumNumberOfLines = 0
        
        view.onHeightChange = {
            self.detonator.performLayout()
        }
        
        return view
    }
    
    override public func patchView() {
        let view = view as! TextAreaView
        
        let attributes = attributes as! TextAreaAttributes
        let currentAttributes = currentAttributes as! TextAreaAttributes?
        
        let placeholder = attributes.placeholder
        let currentPlaceholder = currentAttributes?.placeholder
        
        let patchPlaceholder = forcePatch || placeholder != currentPlaceholder
        
        if patchPlaceholder {
            // view.placeholder = placeholder
        }
        
        let value = attributes.value
        
        let patchValue = forcePatch
        
        if patchValue {
            view.text = value
        }
    }
    
    override func patchPadding(
        padding: Float?,
        paddingTop: Float?,
        paddingLeft: Float?,
        paddingBottom: Float?,
        paddingRight: Float?
    ) {
        let view = view as! TextAreaView
        
        let tmpPadding = padding ?? 0
        
        let tmpPaddingTop = paddingTop ?? tmpPadding
        let tmpPaddingLeft = paddingLeft ?? tmpPadding
        let tmpPaddingBottom = paddingBottom ?? tmpPadding
        let tmpPaddingRight = paddingRight ?? tmpPadding
        
        view.textContainerInset = UIEdgeInsets(
            top: CGFloat(tmpPaddingTop),
            left: CGFloat(tmpPaddingLeft),
            bottom: CGFloat(tmpPaddingBottom),
            right: CGFloat(tmpPaddingRight)
        )
    }
    
    override func patchFontSize(fontSize: Float?) {
        let view = view as! TextAreaView
        
        let value = CGFloat(fontSize ?? 16)
        
        view.font = UIFont.systemFont(ofSize: value)
    }
    
    override func patchColor(color: StyleColor?) {
        let view = view as! TextAreaView
        
        view.textColor = color != nil ? ColorHelper.parseColor(color: color!) : nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let data = OnChangeData(value: textView.text ?? "")
        
        self.detonator.handlerEmitter.emit(name: "onChange", edgeId: edge.id, data: data)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return view.isFirstResponder
    }
    
    struct OnChangeData: Encodable {
        let value: String
    }
    
    class TextAreaAttributes: Attributes {
        var placeholder: String?
        var value: String?
        var onChange: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder)
            value = try container.decodeIfPresent(String.self, forKey: .value)
            onChange = try container.decodeIfPresent(Bool.self, forKey: .onChange)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case placeholder
            case value
            case onChange
        }
    }
}
