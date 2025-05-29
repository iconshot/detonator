import Foundation

class FileStreamModule: Module {
    override func register() {
        detonator.setMessageListener("com.iconshot.detonator.filestream.read::run") { value in
            let data: ReadData! = self.detonator.decode(value)
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    guard let fileURL = URL(string: data.path) else {
                        let error = NSError(domain: "com.iconshot.detonator.filestream.read", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not a valid path."])
                        
                        throw error
                    }
                    
                    let base64 = try self.readFileBase64Chunk(fileURL: fileURL, offset: data.offset, size: data.size)
                    
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
    
    private func readFileBase64Chunk(fileURL: URL, offset: Int, size: Int) throws -> String {
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
    
    struct ReadData: Decodable {
        let id: Int
        let path: String
        let offset: Int
        let size: Int
    }
}
