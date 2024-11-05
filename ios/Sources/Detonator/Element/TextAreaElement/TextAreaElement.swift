import UIKit

class TextAreaElement: Element, UIGestureRecognizerDelegate, UITextViewDelegate {
    private let defaultPlaceholderColor: UIColor = UIColor(white: 1, alpha: 0.75)
    
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
        
        return view
    }
    
    override public func patchView() {
        let view = view as! TextAreaView
        
        let attributes = attributes as! TextAreaAttributes
        let currentAttributes = currentAttributes as! TextAreaAttributes?
        
        let placeholder = attributes.placeholder
        let currentPlaceholder = currentAttributes?.placeholder
        
        let patchPlaceholderBool = forcePatch || placeholder != currentPlaceholder
        
        if patchPlaceholderBool {
            view.placeholder.text = placeholder
        }
        
        let placeholderColor = attributes.placeholderColor
        let currentPlaceholderColor = currentAttributes?.placeholderColor
        
        let patchPlaceholderColorBool = forcePatch || CompareHelper.compareStyleColors(placeholderColor, currentPlaceholderColor)
        
        if patchPlaceholderColorBool {
            view.placeholder.textColor = placeholderColor != nil ? ColorHelper.parseColor(color: placeholderColor!) : defaultPlaceholderColor
        }
        
        let value = attributes.value
        
        let patchValueBool = forcePatch
        
        if patchValueBool {
            view.text = value
        }
        
        let autoCapitalize = attributes.autoCapitalize
        let currentAutoCapitalize = currentAttributes?.autoCapitalize
        
        let patchAutoCapitalizeBool = forcePatch || autoCapitalize != currentAutoCapitalize
        
        if patchAutoCapitalizeBool {
            patchInputType(autoCapitalize: autoCapitalize)
        }
    }
    
    private func patchInputType(autoCapitalize: String?) {
        let view = view as! TextAreaView
        
        switch autoCapitalize {
        case "characters":
            view.autocapitalizationType = .allCharacters
            
            break
            
        case "words":
            view.autocapitalizationType = .words
            
            break
            
        case "sentences":
            view.autocapitalizationType = .sentences
            
            break
            
        case "none":
            view.autocapitalizationType = .none
            
            break
            
        default:
            view.autocapitalizationType = .sentences
            
            break
        }
        
        if view.isFirstResponder {
            view.resignFirstResponder()
            
            view.becomeFirstResponder()
        }
    }
    
    override func patchPadding(
        padding: Float?,
        paddingHorizontal: Float?,
        paddingVertical: Float?,
        paddingTop: Float?,
        paddingLeft: Float?,
        paddingBottom: Float?,
        paddingRight: Float?
    ) {
        let view = view as! TextAreaView
        
        let tmpPadding = padding ?? 0
        
        var tmpPaddingTop = tmpPadding
        var tmpPaddingLeft = tmpPadding
        var tmpPaddingBottom = tmpPadding
        var tmpPaddingRight = tmpPadding
        
        if paddingHorizontal != nil {
            tmpPaddingLeft = paddingHorizontal!
            tmpPaddingRight = paddingHorizontal!
        }
        
        if paddingVertical != nil {
            tmpPaddingTop = paddingVertical!
            tmpPaddingBottom = paddingVertical!
        }
        
        if paddingTop != nil {
            tmpPaddingTop = paddingTop!
        }
        
        if paddingLeft != nil {
            tmpPaddingLeft = paddingLeft!
        }
        
        if paddingBottom != nil {
            tmpPaddingBottom = paddingBottom!
        }
        
        if paddingRight != nil {
            tmpPaddingRight = paddingRight!
        }
        
        view.textContainerInset = UIEdgeInsets(
            top: CGFloat(tmpPaddingTop),
            left: CGFloat(tmpPaddingLeft),
            bottom: CGFloat(tmpPaddingBottom),
            right: CGFloat(tmpPaddingRight)
        )
        
        view.placeholder.layoutParams.padding = LayoutInsets(
            top: tmpPaddingTop,
            left: tmpPaddingLeft,
            bottom: tmpPaddingBottom,
            right: tmpPaddingRight
        )
    }
    
    override func patchFontSize(fontSize: Float?) {
        let view = view as! TextAreaView
        
        let value = CGFloat(fontSize ?? 16)
        
        view.font = UIFont.systemFont(ofSize: value)
        
        view.placeholder.font = view.font
    }
    
    override func patchColor(color: StyleColor?) {
        let view = view as! TextAreaView
        
        view.textColor = color != nil ? ColorHelper.parseColor(color: color!) : nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let data = OnChangeData(value: textView.text ?? "")
        
        detonator.emitHandler(name: "onChange", edgeId: edge.id, data: data)
        
        detonator.performLayout()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return view.isFirstResponder
    }
    
    struct OnChangeData: Encodable {
        let value: String
    }
    
    class TextAreaAttributes: Attributes {
        var placeholder: String?
        var placeholderColor: StyleColor?
        var value: String?
        var autoCapitalize: String?
        var onChange: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder)
            placeholderColor = try container.decodeIfPresent(StyleColor.self, forKey: .placeholderColor)
            value = try container.decodeIfPresent(String.self, forKey: .value)
            autoCapitalize = try container.decodeIfPresent(String.self, forKey: .autoCapitalize)
            onChange = try container.decodeIfPresent(Bool.self, forKey: .onChange)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case placeholder
            case placeholderColor
            case value
            case autoCapitalize
            case onChange
        }
    }
}
