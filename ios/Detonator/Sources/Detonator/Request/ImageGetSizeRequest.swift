import Foundation
import UIKit

class ImageGetSizeRequest: Request {
    override public func run() {
        let source: String! = decodeData()
        
        if source.starts(with: "file://") {
            guard let fileURL = URL(string: source) else {
                let error = NSError(domain: "com.iconshot.detonator.image/getSize", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not a valid source."])
                
                self.error(error: error)

                return
            }
            
            guard let data = try? Data(contentsOf: fileURL) else {
                let error = NSError(domain: "com.iconshot.detonator.image/getSize", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not load file from local path."])
                
                self.error(error: error)
                
                return
            }
            
            guard let image = UIImage(data: data) else {
                let error = NSError(domain: "com.iconshot.detonator.image/getSize", code: 0, userInfo: [NSLocalizedDescriptionKey: "File is not an image."])
                
                self.error(error: error)
                
                return
            }
            
            let size = image.size
            
            let imageSize = ImageSize(width: Int(size.width), height: Int(size.height))
            
            end(data: imageSize)
            
            return
        }
        
        ImageHelper.getImageSize(urlString: source) { size, error in
            if let error = error {
                self.error(error: error)
                
                return
            }
            
            let imageSize = ImageSize(width: Int(size!.width), height: Int(size!.height))
            
            self.end(data: imageSize)
        }
    }
    
    struct ImageSize: Encodable {
        let width: Int
        let height: Int
    }
}
