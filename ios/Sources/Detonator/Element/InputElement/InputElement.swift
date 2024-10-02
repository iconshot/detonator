import UIKit

class InputElement: Element, UIGestureRecognizerDelegate, UITextFieldDelegate {
    override public func decodeAttributes(edge: Edge) -> InputAttributes? {
        return super.decodeAttributes(edge: edge)
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
        let currentAttributes = currentAttributes as! InputAttributes?
        
        let placeholder = attributes.placeholder
        let currentPlaceholder = currentAttributes?.placeholder
        
        let patchPlaceholder = forcePatch || placeholder != currentPlaceholder
        
        let placeholderColor = attributes.placeholderColor
        let currentPlaceholderColor = currentAttributes?.placeholderColor
        
        let patchPlaceholderColor = forcePatch || !CompareHelper.compareStyleColors(placeholderColor, currentPlaceholderColor)
        
        if patchPlaceholder || patchPlaceholderColor {
            if placeholder != nil {
                var attributes: [NSAttributedString.Key: Any] = [:]
                
                attributes[.foregroundColor] = placeholderColor != nil ? ColorHelper.parseColor(color: placeholderColor!) : UIColor.placeholderText
                
                view.placeholder = nil
                
                view.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: attributes)
            } else {
                view.placeholder = nil
                
                view.attributedPlaceholder = nil
            }
        }
        
        let value = attributes.value
        
        let patchValue = forcePatch
        
        if patchValue {
            view.text = value
        }
        
        let inputType = attributes.inputType
        let currentInputType = currentAttributes?.inputType
        
        let patchInputType = forcePatch || inputType != currentInputType
        
        if patchInputType {
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
    
    func textFieldShouldReturn(_ view: UITextField) -> Bool {
        view.resignFirstResponder()

        detonator.handlerEmitter.emit(name: "onDone", edgeId: edge.id)
        
        return true
    }
    
    @objc private func onChangeListener(_ view: UITextField) {
        let data = OnChangeData(value: view.text ?? "")
        
        detonator.handlerEmitter.emit(name: "onChange", edgeId: edge.id, data: data)
        
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
        var onChange: Bool?
        var onDone: Bool?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder)
            placeholderColor = try container.decodeIfPresent(StyleColor.self, forKey: .placeholderColor)
            value = try container.decodeIfPresent(String.self, forKey: .value)
            inputType = try container.decodeIfPresent(String.self, forKey: .inputType)
            onChange = try container.decodeIfPresent(Bool.self, forKey: .onChange)
            onDone = try container.decodeIfPresent(Bool.self, forKey: .onDone)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case placeholder
            case placeholderColor
            case value
            case inputType
            case onChange
            case onDone
        }
    }
}
