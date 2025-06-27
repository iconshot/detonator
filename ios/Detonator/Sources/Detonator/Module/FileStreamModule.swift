import Foundation
import Photos

class FileStreamModule: Module {
    private var dataMap: [Int: Data] = [:]
    
    override func register() {
        detonator.setMessageListener("com.iconshot.detonator.filestream.read::run") { value in
            let data: ReadData! = self.detonator.decode(value)
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    var base64: String = ""
                    
                    if data.path.starts(with: "file://") {
                        base64 = try self.readFileBase64ChunkFromFile(
                            id: data.id,
                            path: data.path,
                            offset: data.offset,
                            size: data.size
                        )
                    } else if data.path.starts(with: "content://") {
                        base64 = try self.readFileBase64ChunkFromContent(
                            id: data.id,
                            path: data.path,
                            offset: data.offset,
                            size: data.size
                        )
                    } else {
                        throw NSError(domain: "com.iconshot.detonator.filestream.read", code: 1, userInfo: [NSLocalizedDescriptionKey: "Path not supported."])
                    }
                    
                    let dataValue = "\(data.id)\n\(base64)"
                    
                    DispatchQueue.main.async {
                        self.detonator.emit("com.iconshot.detonator.filestream.read.data", dataValue)
                    }
                } catch {
                    let errorValue = "\(data.id)\n\(error.localizedDescription)"
                    
                    DispatchQueue.main.async {
                        self.detonator.emit("com.iconshot.detonator.filestream.read.error", errorValue)
                    }
                }
            }
        }
    }
    
    private func readFileBase64ChunkFromFile(id: Int, path: String, offset: Int, size: Int) throws -> String {
        guard let fileURL = URL(string: path) else {
            throw NSError(domain: "com.iconshot.detonator.filestream.read", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid path."])
        }
        
        let fileHandle = try FileHandle(forReadingFrom: fileURL)

        defer {
            try? fileHandle.close()
        }

        let fileSize = try fileHandle.seekToEndOfFile()
        
        if offset >= fileSize {
            return ""
        }

        try fileHandle.seek(toOffset: UInt64(offset))
        
        let data = fileHandle.readData(ofLength: size)
        
        let base64 = data.base64EncodedString()
        
        return base64
    }
    
    private func readFileBase64ChunkFromContent(id: Int, path: String, offset: Int, size: Int) throws -> String {
        var resultData = dataMap[id]
        
        var resultError: Error?
        
        if resultData == nil {
            let localIdentifier = path.replacingOccurrences(of: "content://", with: "")

            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)

            guard let asset = assets.firstObject else {
                throw NSError(domain: "com.iconshot.detonator.filestream.read", code: 2, userInfo: [NSLocalizedDescriptionKey: "Asset not found."])
            }
            
            let semaphore = DispatchSemaphore(value: 0)
            
            switch asset.mediaType {
            case .image:
                let options = PHImageRequestOptions()
                
                options.isSynchronous = false
                options.isNetworkAccessAllowed = true
                options.deliveryMode = .highQualityFormat
                
                PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { data, _, _, info in
                    resultData = data
                    resultError = info?[PHImageErrorKey] as? Error
                    
                    semaphore.signal()
                }
            
            case .video:
                PHImageManager.default().requestAVAsset(forVideo: asset, options: nil) { avAsset, _, _ in
                    if let urlAsset = avAsset as? AVURLAsset {
                        do {
                            resultData = try Data(contentsOf: urlAsset.url)
                        } catch {
                            resultError = error
                        }
                    } else {
                        resultError = NSError(domain: "com.iconshot.detonator.filestream.read", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not load AVAsset."])
                    }
                    
                    semaphore.signal()
                }
                
            default:
                throw NSError(domain: "com.iconshot.detonator.filestream.read", code: 4, userInfo: [NSLocalizedDescriptionKey: "Unsupported media type."])
            }
            
            _ = semaphore.wait(timeout: .now() + 10)

            if let error = resultError {
                throw error
            }
                        
            dataMap[id] = resultData
        }

        guard let data = resultData else {
            throw NSError(domain: "com.iconshot.detonator.filestream.read", code: 5, userInfo: [NSLocalizedDescriptionKey: "No data returned."])
        }

        if offset >= data.count {
            dataMap[id] = nil
            
            return ""
        }

        let end = min(data.count, offset + size)
        
        let chunk = data.subdata(in: offset..<end)
        
        let base64 = chunk.base64EncodedString()
        
        return base64
    }
    
    struct ReadData: Decodable {
        let id: Int
        let path: String
        let offset: Int
        let size: Int
    }
}
