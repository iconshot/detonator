import Foundation

class Storage {
    let name: String
    
    public var content: [String: String] {
        didSet {
            Storage.write(name: name, content: content)
        }
    }
    
    init(name: String) {
        self.name = name
        
        if let currentContent = Storage.read(name: name) {
            content = currentContent
        } else {
            content = [:]
        }
    }
    
    private static func getFileURL(name: String) -> URL {
        let fileName = "\(name).plist"
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    private static func read(name: String) -> [String: String]? {
        let fileURL = getFileURL(name: name)
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            let content = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String]
            
            return content
        } catch {
            return nil
        }
    }
    
    private static func write(name: String, content: [String: String]) {
        let fileURL = getFileURL(name: name)
        
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: content, format: .xml, options: 0)
            
            try data.write(to: fileURL, options: .atomic)
        } catch {}
    }
}
