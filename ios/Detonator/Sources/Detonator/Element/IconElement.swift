import UIKit

class IconElement: Element {
    override func decodeAttributes() -> IconAttributes? {
        return super.decodeAttributes()
    }
    
    override func createView() -> TextView {
        return TextView()
    }
    
    override func setUpView() -> Void {
        let view = view as! TextView
        
        view.isUserInteractionEnabled = true
    }

    override func patchView() -> Void {
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
    
    override func patchFontSize(fontSize: Float?) -> Void {
        let view = view as! TextView
        
        let value = CGFloat(fontSize ?? 16)
        
        view.font = view.font.withSize(value)
    }
    
    override func patchColor(color: StyleColor?) -> Void {
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
