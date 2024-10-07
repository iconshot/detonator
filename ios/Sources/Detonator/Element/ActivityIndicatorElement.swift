import UIKit

class ActivityIndicatorElement: Element {
    override public func decodeAttributes(edge: Edge) -> ActivityIndicatorAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        
        view.startAnimating()
        
        return view
    }
    
    override public func patchView() {
        let view = view as! UIActivityIndicatorView
        
        let attributes = attributes as! ActivityIndicatorAttributes
        let currentAttributes = currentAttributes as! ActivityIndicatorAttributes?
        
        let size = attributes.size
        let currentSize = currentAttributes?.size
        
        let patchSizeBool = forcePatch || size != currentSize
        
        if patchSizeBool {
            switch size {
            case "medium":
                view.style = .medium
                
                break
                
            case "large":
                view.style = .large
                
                break
                
            default:
                view.style = .medium
                
                break
            }
        }
    }
    
    override func patchColor(color: StyleColor?) {
        let view = view as! UIActivityIndicatorView
        
        view.color = color != nil ? ColorHelper.parseColor(color: color!) : nil
    }

    class ActivityIndicatorAttributes: Attributes {
        var size: String?

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            size = try container.decodeIfPresent(String.self, forKey: .size)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case size
        }
    }
}