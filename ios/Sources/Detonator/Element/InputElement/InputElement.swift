import UIKit

class InputElement: Element, UIGestureRecognizerDelegate, UITextFieldDelegate {
    private let defaultPlaceholderColor: UIColor = UIColor(white: 1, alpha: 0.75)
    
    override public func decodeAttributes() -> InputAttributes? {
        return super.decodeAttributes()
    }
    
    override public func createView() -> InputView {
        let view = InputView()
        
        view.delegate = self
        
        tapGestureRecognizer.delegate = self
        
        view.addTarget(self, action: #selector(onChangeListener(_:)), for: .editingChanged)
        
        return view
    }
    
    override public func patchView() {
        let view = view as! InputView
        
        let attributes = attributes as! InputAttributes
        let prevAttributes = prevAttributes as! InputAttributes?
        
        let placeholder = attributes.placeholder
        let prevPlaceholder = prevAttributes?.placeholder
        
        let patchPlaceholderBool = forcePatch || placeholder != prevPlaceholder
        
        let placeholderColor = attributes.placeholderColor
        let prevPlaceholderColor = prevAttributes?.placeholderColor
        
        let patchPlaceholderColorBool = forcePatch || !CompareHelper.compareStyleColors(placeholderColor, prevPlaceholderColor)
        
        if patchPlaceholderBool || patchPlaceholderColorBool {
            if placeholder != nil {
                var attributes: [NSAttributedString.Key: Any] = [:]
                
                attributes[.foregroundColor] = placeholderColor != nil ? ColorHelper.parseColor(color: placeholderColor!) : defaultPlaceholderColor
                
                view.placeholder = nil
                
                view.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: attributes)
            } else {
                view.placeholder = nil
                
                view.attributedPlaceholder = nil
            }
        }
        
        let value = attributes.value
        
        let patchValueBool = forcePatch
        
        if patchValueBool {
            view.text = value
        }
        
        let inputType = attributes.inputType
        let prevInputType = prevAttributes?.inputType
        
        let patchInputTypeBool = forcePatch || inputType != prevInputType
        
        let autoCapitalize = attributes.autoCapitalize
        let prevAutoCapitalize = prevAttributes?.autoCapitalize
        
        let patchAutoCapitalizeBool = forcePatch || autoCapitalize != prevAutoCapitalize
        
        if patchInputTypeBool || patchAutoCapitalizeBool {
            patchInputType(inputType: inputType, autoCapitalize: autoCapitalize)
        }
    }
    
    private func patchInputType(inputType: String?, autoCapitalize: String?) {
        let view = view as! InputView
        
        switch inputType {
        case "text":
            view.keyboardType = .default
            
            break
            
        case "password":
            view.keyboardType = .default
            
            break
            
        case "email":
            view.keyboardType = .emailAddress
            
            break
            
        default:
            view.keyboardType = .default
            
            break
        }
        
        view.isSecureTextEntry = inputType == "password"
        
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
    
    override func patchFontSize(fontSize: Float?) {
        let view = view as! InputView
        
        let value = CGFloat(fontSize ?? 16)
        
        view.font = UIFont.systemFont(ofSize: value)
    }
    
    override func patchColor(color: StyleColor?) {
        let view = view as! InputView
        
        view.textColor = color != nil ? ColorHelper.parseColor(color: color!) : nil
    }
    
    func updateValue(value: String) {
        let view = view as! InputView
        
        view.text = value
        
        view.sendActions(for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ view: UITextField) -> Bool {
        view.resignFirstResponder()

        detonator.emitHandler(name: "onDone", edgeId: edge.id)
        
        return true
    }
    
    @objc private func onChangeListener(_ view: UITextField) {
        let data = OnChangeData(value: view.text ?? "")
        
        detonator.emitHandler(name: "onChange", edgeId: edge.id, data: data)
        
        detonator.performLayout()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return view.isFirstResponder
    }
    
    struct OnChangeData: Encodable {
        let value: String
    }
    
    class InputAttributes: Attributes {
        var placeholder: String?
        var placeholderColor: StyleColor?
        var value: String?
        var inputType: String?
        var autoCapitalize: String?
        var onChange: Bool?
        var onDone: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder)
            placeholderColor = try container.decodeIfPresent(StyleColor.self, forKey: .placeholderColor)
            value = try container.decodeIfPresent(String.self, forKey: .value)
            inputType = try container.decodeIfPresent(String.self, forKey: .inputType)
            autoCapitalize = try container.decodeIfPresent(String.self, forKey: .autoCapitalize)
            onChange = try container.decodeIfPresent(Bool.self, forKey: .onChange)
            onDone = try container.decodeIfPresent(Bool.self, forKey: .onDone)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case placeholder
            case placeholderColor
            case value
            case inputType
            case autoCapitalize
            case onChange
            case onDone
        }
    }
}
