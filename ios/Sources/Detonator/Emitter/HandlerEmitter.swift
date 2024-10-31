public class HandlerEmitter: Emitter {
    public func emit(name: String, edgeId: Int, data: Encodable?) {
        let handler = Handler(name: name, edgeId: edgeId, data: data)
        
        detonator.emit(name: "handler", value: handler)
    }
    
    struct Handler: Encodable {
        let name: String
        let edgeId: Int
        let data: AnyEncodable??

        init(name: String, edgeId: Int, data: Encodable?) {
            self.name = name
            self.edgeId = edgeId
            
            if let data = data {
                self.data = AnyEncodable(data)
            } else {
                self.data = .some(nil)
            }
        }
    }
}
