import Foundation
import UIKit
import CommonCrypto

class ImageHelper {
    public static func loadImage(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "com.iconshot.detonator.ImageHelper", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL string is not valid."])
            
            completion(nil, error)
            
            return
        }
        
        let fileManager = FileManager.default
        
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        let fileName = getFileName(urlString: urlString)
        
        let fileURL = cacheDir.appendingPathComponent(fileName)
        
        // check if the image is already cached in the file system
        
        if fileManager.fileExists(atPath: fileURL.path) {
            // load the image data from the cache
            
            do {
                let data = try Data(contentsOf: fileURL)
                
                completion(data, nil)
                
                return
            } catch {
                let error = NSError(domain: "com.iconshot.detonator.ImageHelper", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load data from file.", NSUnderlyingErrorKey: error])
                
                completion(nil, error)
                
                return
            }
        }
        
        // download the image data
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "com.iconshot.detonator.ImageHelper", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response."])
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "com.iconshot.detonator.ImageHelper", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP status code \(httpResponse.statusCode)."])
            
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.iconshot.detonator.ImageHelper", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get data from response."])
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                return
            }
            
            // save the data to the file cache
            
            do {
                try data.write(to: fileURL)
            } catch {
                let error = NSError(domain: "com.iconshot.detonator.ImageHelper", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to save data to cache."])
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                return
            }
            
            // call the completion handler with the data
            
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }.resume()
    }
    
    public static func getImageSize(urlString: String, completion: @escaping (CGSize?, Error?) -> Void) {
        loadImage(urlString: urlString) { data, error in
            if error != nil {
                completion(nil, error)
            } else {
                if let image = UIImage(data: data!) {
                    let size = image.size
                    
                    completion(size, nil)
                } else {
                    let error = NSError(domain: "com.iconshot.detonator.ImageHelper", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to UIImage."])
                    
                    completion(nil, error)
                }
            }
        }
    }
    
    public static func getFileName(urlString: String) -> String {
        if let data = SHA256Hash(urlString) {
            let hexString = data.map { String(format: "%02hhx", $0) }.joined()
            
            return hexString
        }
        
        return (urlString as NSString).lastPathComponent
    }
    
    public static func SHA256Hash(_ string: String) -> Data? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = data.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        
        return Data(digest)
    }
}
