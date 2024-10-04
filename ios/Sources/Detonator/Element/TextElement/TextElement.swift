import UIKit

class TextElement: Element {
    override public func decodeAttributes(edge: Edge) -> TextAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> TextView {
        let view = TextView()
        
        view.isUserInteractionEnabled = true
        
        return view
    }
    
    override public func patchView() {
        let view = view as! TextView
        
        let attributes = attributes as! TextAttributes
        let currentAttributes = currentAttributes as! TextAttributes?
        
        let stringBuilder = NSMutableString()
        
        for child in edge!.children {
            if let text = child.text {
                stringBuilder.append(text)
            }
        }
        
        let text = stringBuilder as String
        
        if text != view.text {
            view.text = text
        }
        
        let maxLines = attributes.maxLines
        let currentMaxLines = currentAttributes?.maxLines
        
        let patchMaxLinesBool = forcePatch || maxLines != currentMaxLines
        
        if patchMaxLinesBool {
            let value = maxLines ?? 0
            
            view.numberOfLines = value
        }
    }
    
    override func patchFontSize(fontSize: Float?) {
        let view = view as! TextView
        
        let value = CGFloat(fontSize ?? 16)
        
        view.font = UIFont.systemFont(ofSize: value)
    }
    
    override func patchColor(color: StyleColor?) {
        let view = view as! TextView
        
        view.textColor = color != nil ? ColorHelper.parseColor(color: color!) : nil
    }
    
    class TextAttributes: Attributes {
        var maxLines: Int?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            maxLines = try container.decodeIfPresent(Int.self, forKey: .maxLines)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case maxLines
        }
    }
}
