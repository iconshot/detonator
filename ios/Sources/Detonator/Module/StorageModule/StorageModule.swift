import Foundation

class StorageModule: Module {
    override func register() {
        detonator.addRequestClass(key: "com.iconshot.detonator.storage/getItem", requestClass: StorageGetItemRequest.self)
        detonator.addRequestClass(key: "com.iconshot.detonator.storage/setItem", requestClass: StorageSetItemRequest.self)
    }
    
    private static var map: [String: Storage] = [:]
    
    private static func getStorage(name: String) -> Storage {
        if let storage = map[name] {
            return storage
        }
        
        let storage = Storage(name: name)
        
        map[name] = storage
        
        return storage
    }
    
    class StorageGetItemRequest: Request {
        override func run() {
            let data: Data = decode()!
            
            let storage = StorageModule.getStorage(name: data.name)
            
            let value = storage.content[data.key]
            
            end(data: value)
        }
        
        struct Data: Decodable {
            let name: String
            let key: String
        }
    }
    
    class StorageSetItemRequest: Request {
        override func run() {
            let data: Data = decode()!
            
            let storage = StorageModule.getStorage(name: data.name)
            
            storage.content[data.key] = data.value
            
            end()
        }
        
        struct Data: Decodable {
            let name: String
            let key: String
            let value: String
        }
    }
}
