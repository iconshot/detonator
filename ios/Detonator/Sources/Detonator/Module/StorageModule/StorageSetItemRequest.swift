class StorageSetItemRequest: Request {
    override func run() {
        let data: Data! = decodeData()
        
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
