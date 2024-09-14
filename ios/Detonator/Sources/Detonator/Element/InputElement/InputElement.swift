import UIKit

class InputElement: Element, UIGestureRecognizerDelegate, UITextFieldDelegate {
    override public func decodeAttributes(edge: Edge) -> InputAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> InputView {
        let view = InputView()
        
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
        
        if patchPlaceholder {
             view.placeholder = placeholder
        }
        
        let value = attributes.value
        
        let patchValue = forcePatch
        
        if patchValue {
            view.text = value
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
    
    @objc private func onChangeListener(_ view: UITextField) {
        let data = OnChangeData(value: view.text ?? "")
        
        detonator.handlerEmitter.emit(name: "onChange", edgeId: edge.id, data: data)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return view.isFirstResponder
    }
    
    struct OnChangeData: Encodable {
        let value: String
    }
    
    class InputAttributes: Attributes {
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
