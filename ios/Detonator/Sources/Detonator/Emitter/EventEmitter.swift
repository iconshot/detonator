class EventEmitter: Emitter {
    public func emit(name: String, data: Encodable? = nil) {
        let handler = Event(name: name, data: data)
        
        detonator.emit(name: "event", value: handler)
    }
    
    struct Event: Encodable {
        let name: String
        let data: AnyEncodable?

        init(name: String, data: Encodable?) {
            self.name = name
            
            if let data = data {
                self.data = AnyEncodable(data)
            } else {
                self.data = nil
            }
        }
    }
}
