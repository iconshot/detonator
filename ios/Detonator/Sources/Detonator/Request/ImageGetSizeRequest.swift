import Foundation
import UIKit
import Photos

class ImageGetSizeRequest: Request {
    override public func run() {
        let source: String! = decodeData()
        
        if source.starts(with: "file://") {
            guard let fileURL = URL(string: source) else {
                self.error(message: "Not a valid source.")

                return
            }
            
            guard let data = try? Data(contentsOf: fileURL) else {
                self.error(message: "Could not load file from local path.")
                
                return
            }
            
            guard let image = UIImage(data: data) else {
                self.error(message: "File is not an image.")
                
                return
            }
            
            let size = image.size
            
            let imageSize = ImageSize(width: Int(size.width), height: Int(size.height))
            
            end(data: imageSize)
            
            return
        }
        
        if source.starts(with: "content://") {
            let localIdentifier = source.replacingOccurrences(of: "content://", with: "")
            
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
                
            guard let asset = assets.firstObject else {
                self.error(message: "Asset not found.")
                
                return
            }
            
            if asset.mediaType != .image {
                self.error(message: "Asset is not an image.")
                
                return
            }
            
            let size = ImageSize(width: asset.pixelWidth, height: asset.pixelHeight)
            
            end(data: size)
            
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
