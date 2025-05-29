class StorageGetItemRequest: Request {
    override func run() {
        let data: Data! = decodeData()
        
        let storage = StorageModule.getStorage(name: data.name)
        
        let value = storage.content[data.key]
        
        end(data: value)
    }
    
    struct Data: Decodable {
        let name: String
        let key: String
    }
}
