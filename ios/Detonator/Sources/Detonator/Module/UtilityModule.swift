import Foundation
import UIKit
import Photos

class UtilityModule: Module {
    public override func setUp() -> Void {
        detonator.setEventListener("com.iconshot.detonator::log") { value in
            let str = String(value.dropFirst().dropLast())
            
            print(str)
        }
        
        detonator.setRequestListener("com.iconshot.detonator::openUrl") { promise, value, edge in
            guard let url = URL(string: value) else {
                promise.reject("Not a valid url.")
                
                return
            }
            
            if !UIApplication.shared.canOpenURL(url) {
                promise.reject("Can't open url.")
                
                return
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            promise.resolve()
        }
        
        detonator.setRequestListener("com.iconshot.detonator.imagesize::getSize") { promise, value, edge in
            let source = value
            
            if source.starts(with: "file://") {
                guard let fileURL = URL(string: source) else {
                    promise.reject("Not a valid source.")

                    return
                }
                
                guard let data = try? Data(contentsOf: fileURL) else {
                    promise.reject("Could not load file from local path.")
                    
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    promise.reject("File is not an image.")
                    
                    return
                }
                
                let size = image.size
                
                let imageSize = ImageSize(width: Int(size.width), height: Int(size.height))
                
                promise.resolve(imageSize)
                
                return
            }
            
            if source.starts(with: "content://") {
                let localIdentifier = source.replacingOccurrences(of: "content://", with: "")
                
                let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
                    
                guard let asset = assets.firstObject else {
                    promise.reject("Asset not found.")
                    
                    return
                }
                
                if asset.mediaType != .image {
                    promise.reject("Asset is not an image.")
                    
                    return
                }
                
                let size = ImageSize(width: asset.pixelWidth, height: asset.pixelHeight)
                
                promise.resolve(size)
                
                return
            }
            
            ImageHelper.getImageSize(urlString: source) { size, error in
                if let error = error {
                    promise.reject(error)
                    
                    return
                }
                
                let imageSize = ImageSize(width: Int(size!.width), height: Int(size!.height))
                
                promise.resolve(imageSize)
            }
        }
    }
    
    private struct ImageSize: Encodable {
        let width: Int
        let height: Int
    }
}
