import UIKit

class ImageElement: Element {
    override public func decodeAttributes(edge: Edge) -> ImageAttributes? {
        return super.decodeAttributes(edge: edge)
    }
    
    override public func createView() -> UIImageView {
        let view = UIImageView()
        
        view.isUserInteractionEnabled = true
        
        return view
    }
    
    override public func patchView() {
        let attributes = attributes as! ImageAttributes
        let currentAttributes = currentAttributes as! ImageAttributes?
        
        let url = attributes.url
        let currentUrl = currentAttributes?.url
        
        if forcePatch || url != currentUrl {
            patchUrl(urlString: url)
        }
    }
    
    private func patchUrl(urlString: String?) {
        let view = view as! UIImageView
        
        if let urlString = urlString {
            ImageHelper.loadImage(urlString: urlString) { data, error in
                if error != nil {
                    view.image = nil
                } else {
                    if let image = UIImage(data: data!) {
                        view.image = image
                    } else {
                        view.image = nil
                    }
                }
            }
        } else {
            view.image = nil
        }
    }
    
    override func patchObjectFit(objectFit: String?) {
        let view = view as! UIImageView

        switch objectFit {
        case "cover":
            view.contentMode = .scaleAspectFill
            
            break
            
        case "contain":
            view.contentMode = .scaleAspectFit
            
            break
            
        case "fill":
            view.contentMode = .scaleToFill
            
            break
            
        default:
            view.contentMode = .scaleAspectFill
            
            break
        }
    }
    
    class ImageAttributes: Attributes {
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
