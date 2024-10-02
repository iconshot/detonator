import UIKit

class VideoElement: Element {
    override public func decodeAttributes(edge: Edge) -> VideoAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> VideoView {
        return VideoView()
    }
    
    override public func patchView() {
        let view = view as! VideoView
        
        let attributes = self.attributes as! VideoAttributes
        let currentAttributes = self.currentAttributes as! VideoAttributes?
        
        let url = attributes.url
        let currentUrl = currentAttributes?.url
        
        let patchUrl = forcePatch || url != currentUrl
        
        if patchUrl {
            view.setupPlayer(urlString: url)
        }
    }
    
    override func patchObjectFit(objectFit: String?) {
        let view = view as! VideoView
        
        switch objectFit {
        case "cover":
            view.objectFit = .cover
            
            break
            
        case "contain":
            view.objectFit = .contain
            
            break
            
        case "fill":
            view.objectFit = .fill
            
            break
            
        default:
            view.objectFit = .cover
            
            break
        }
    }
    
    class VideoAttributes: Attributes {
        var url: String?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            url = try container.decodeIfPresent(String.self, forKey: .url)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case url
        }
    }
}
