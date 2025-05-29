import UIKit

class ImageElement: Element {
    override public func decodeAttributes() -> ImageAttributes? {
        return super.decodeAttributes()
    }
    
    override public func createView() -> UIImageView {
        let view = UIImageView()
        
        view.isUserInteractionEnabled = true
        
        return view
    }
    
    override public func patchView() {
        let attributes = attributes as! ImageAttributes
        let prevAttributes = prevAttributes as! ImageAttributes?
        
        let source = attributes.source
        let prevSource = prevAttributes?.source
        
        let patchSourceBool = forcePatch || source != prevSource
        
        if patchSourceBool {
            patchSource(source: source)
        }
    }
    
    private func patchSource(source: String?) {
        let view = view as! UIImageView
        
        guard let source = source else {
            view.image = nil
            
            return
        }
        
        if source.starts(with: "file://") {
            guard let fileURL = URL(string: source) else {
                view.image = nil
                
                return
            }
            
            guard let data = try? Data(contentsOf: fileURL) else {
                view.image = nil
                
                return
            }
            
            guard let image = UIImage(data: data) else {
                view.image = nil
                
                return
            }

            view.image = image
            
            return
        }
        
        ImageHelper.loadImageData(urlString: source) { data, error in
            if error != nil {
                view.image = nil
                
                return
            }
            
            guard let image = UIImage(data: data!) else {
                view.image = nil
                
                return
            }
            
            view.image = image
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
        var source: String?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            source = try container.decodeIfPresent(String.self, forKey: .source)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case source
        }
    }
}
