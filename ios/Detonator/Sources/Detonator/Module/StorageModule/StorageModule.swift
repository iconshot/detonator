class StorageModule: Module {
    private var storages: [String: Storage] = [:]
    
    private func getStorage(name: String) -> Storage {
        if let storage = storages[name] {
            return storage
        }
        
        let storage = Storage(name: name)
        
        storages[name] = storage
        
        return storage
    }
    
    override func setUp() -> Void {
        detonator.setRequestListener("com.iconshot.detonator.storage::getItem") { promise, value, edge in
            let data: GetItemData = self.detonator.decode(value)!
            
            let storage = self.getStorage(name: data.name)
            
            let itemValue = storage.content[data.key]
            
            promise.resolve(itemValue != nil ? "&\(itemValue)" : ":n")
        }
        
        detonator.setRequestListener("com.iconshot.detonator.storage::setItem") { promise, value, edge in
            let data: SetItemData = self.detonator.decode(value)!
            
            let storage = self.getStorage(name: data.name)
            
            storage.content[data.key] = data.value
            
            promise.resolve()
        }
    }
    
    private struct GetItemData: Decodable {
        let name: String
        let key: String
    }
    
    private struct SetItemData: Decodable {
        let name: String
        let key: String
        let value: String
    }
}
