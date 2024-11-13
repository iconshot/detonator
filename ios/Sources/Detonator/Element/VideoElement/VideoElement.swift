import UIKit

class VideoElement: Element {
    override public func decodeAttributes(edge: Edge) -> VideoAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> VideoView {
        let view = VideoView()
        
        view.onProgressListener = { position in
            let data = OnProgressData(position: position)
            
            self.detonator.emitHandler(name: "onProgress", edgeId: self.edge.id, data: data)
        }
        
        view.onEndListener = {
            self.detonator.emitHandler(name: "onEnd", edgeId: self.edge.id)
        }
        
        return view
    }
    
    override public func patchView() {
        let view = view as! VideoView
        
        let attributes = attributes as! VideoAttributes
        let currentAttributes = currentAttributes as! VideoAttributes?
        
        let url = attributes.url
        let currentUrl = currentAttributes?.url
        
        let patchUrl = forcePatch || url != currentUrl
        
        if patchUrl {
            view.setupPlayer(urlString: url)
        }
    }
    
    override public func removeView() {
        let view = view as! VideoView

        view.remove()
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
    
    struct OnProgressData: Encodable {
        let position: Int
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
