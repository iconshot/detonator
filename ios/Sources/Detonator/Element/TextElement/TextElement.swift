import UIKit

class TextElement: Element {
    override public func decodeAttributes(edge: Edge) -> TextAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> TextView {
        let view = TextView()
        
        view.isUserInteractionEnabled = true
        
        view.numberOfLines = 0
        
        return view
    }
    
    override public func patchView() {
        let view = view as! TextView
        
        let stringBuilder = NSMutableString()
        
        for child in edge!.children {
            if let text = child.text {
                stringBuilder.append(text)
            }
        }
        
        let text = stringBuilder as String
        
        if (text != view.text) {
            view.text = text
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
    
    class TextAttributes: Attributes {}
}
