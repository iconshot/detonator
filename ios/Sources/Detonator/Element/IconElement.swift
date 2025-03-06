import UIKit

class IconElement: Element {
    override public func decodeAttributes(edge: Edge) -> IconAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> TextView {
        let view = TextView()
        
        view.isUserInteractionEnabled = true
        
        return view
    }

    override public func patchView() {
        let view = view as! TextView
        
        let attributes = attributes as! IconAttributes
        let prevAttributes = prevAttributes as! IconAttributes?
        
        let name = attributes.name
        let prevName = prevAttributes?.name
        
        let patchNameBool = forcePatch || name != prevName
        
        if patchNameBool {
            let font = IconHelper.getFont(name: name)
            
            if let font = font {
                view.font = UIFont(name: font, size: view.font.pointSize)
                
                view.text = IconHelper.getIcon(key: name)
            } else {
                view.font = UIFont.systemFont(ofSize: view.font.pointSize)
                
                view.text = nil
            }
        }
    }
    
    override func patchFontSize(fontSize: Float?) {
        let view = view as! TextView
        
        let value = CGFloat(fontSize ?? 16)
        
        view.font = view.font.withSize(value)
    }
    
    override func patchColor(color: StyleColor?) {
        let view = view as! TextView
        
        view.textColor = color != nil ? ColorHelper.parseColor(color: color!) : nil
    }
    
    class IconAttributes: Attributes {
        var name: String

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            name = try container.decode(String.self, forKey: .name)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case name
        }
    }
}
