import UIKit

class Request {
    let detonator: Detonator
    
    let id: Int
    let componentId: Int?
    let data: String?
    
    required init(_ detonator: Detonator, incomingRequest: IncomingRequest) {
        self.detonator = detonator
        
        self.id = incomingRequest.id
        self.componentId = incomingRequest.componentId
        self.data = incomingRequest.data
    }
    
    func decode<T: Decodable>() -> T? {
        if let json = data?.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                
                let attributes = try decoder.decode(T.self, from: json)
                
                return attributes;
            } catch {}
        }
        
        return nil
    }
    
    func getComponentEdge() -> Edge? {
        if componentId == nil {
            return nil
        }
        
        return detonator.getEdge(edgeId: componentId!)
    }
    
    public func run() {}
    
    func end() {
        end(data: nil)
    }
    
    func end(data: Encodable?) {
        let response = OutgoingResponse(id: id, data: data, error: nil)
        
        emit(response: response)
    }
    
    func error(message: String) {
        let tmpError = OutgoingResponse.Error(message: message)
        
        let response = OutgoingResponse(id: id, data: nil, error: tmpError)
        
        emit(response: response)
    }
    
    func error(error: Error) {
        self.error(message: error.localizedDescription)
    }
    
    func emit(response: OutgoingResponse) {
        detonator.emit(name: "response", value: response)
    }
    
    struct IncomingRequest: Decodable {
        let id: Int
        let name: String
        let componentId: Int?
        let data: String?
    }
    
    struct OutgoingResponse: Encodable {
        let id: Int
        let data: NullEncodable<AnyEncodable>?
        let error: NullEncodable<Error>?
        
        init(id: Int, data: Encodable?, error: Error?) {
            self.id = id
            
            if let data = data {
                self.data = NullEncodable(AnyEncodable(data))
            } else {
                self.data = NullEncodable(nil)
            }
            
            self.error = NullEncodable(error)
        }
        
        struct Error: Encodable {
            let message: String
        }
    }
}
