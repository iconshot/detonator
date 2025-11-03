import UIKit

class TextElement: Element {
    override func decodeAttributes() -> TextAttributes? {
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
        
        let attributes = attributes as! TextAttributes
        let prevAttributes = prevAttributes as! TextAttributes?
        
        let stringBuilder = NSMutableString()
        
        for child in edge!.children {
            if let text = child.text {
                stringBuilder.append(text)
            }
        }
        
        let text = stringBuilder as String
        
        let prevText = view.text
        
        let patchTextBool = forcePatch || text != prevText
        
        if patchTextBool {
            view.text = text
        }
        
        let maxLines = attributes.maxLines
        let prevMaxLines = prevAttributes?.maxLines
        
        let patchMaxLinesBool = forcePatch || maxLines != prevMaxLines
        
        if patchMaxLinesBool {
            let value = maxLines ?? 0
            
            view.numberOfLines = value
        }
    }
    
    override func patchFontSize(fontSize: Float?) -> Void {
        let view = view as! TextView
        
        let value = CGFloat(fontSize ?? 16)
        
        view.font = UIFont.systemFont(ofSize: value)
    }
    
    override func patchColor(color: StyleColor?) -> Void {
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
