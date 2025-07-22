class StorageModule: Module {
    override func setUp() -> Void {
        detonator.setRequestClass("com.iconshot.detonator.storage::getItem", StorageGetItemRequest.self)
        detonator.setRequestClass("com.iconshot.detonator.storage::setItem", StorageSetItemRequest.self)
    }
    
    private static var storages: [String: Storage] = [:]
    
    public static func getStorage(name: String) -> Storage {
        if let storage = storages[name] {
            return storage
        }
        
        let storage = Storage(name: name)
        
        storages[name] = storage
        
        return storage
    }
}
