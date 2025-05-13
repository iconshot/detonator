import UIKit

open class Request {
    let detonator: Detonator
    
    let id: Int
    let componentId: Int?
    let data: String?
    
    required public init(_ detonator: Detonator, incomingRequest: IncomingRequest) {
        self.detonator = detonator
        
        self.id = incomingRequest.id
        self.componentId = incomingRequest.componentId
        self.data = incomingRequest.data
    }
    
    public func decodeData<T: Decodable>() -> T? {
        guard let data = data else {
            return nil
        }
        
        return detonator.decode(data)
    }
    
    public func getComponentEdge() -> Edge? {
        if componentId == nil {
            return nil
        }
        
        return detonator.getEdge(edgeId: componentId!)
    }
    
    public func run() {}
    
    public func end() {
        end(data: nil)
    }
    
    public func end(data: Encodable?) {
        let response = OutgoingResponse(id: id, data: data, error: nil)
        
        emit(response: response)
    }
    
    public func error(message: String) {
        let tmpError = OutgoingResponse.Error(message: message)
        
        let response = OutgoingResponse(id: id, data: nil, error: tmpError)
        
        emit(response: response)
    }
    
    public func error(error: Error) {
        self.error(message: error.localizedDescription)
    }
    
    private func emit(response: OutgoingResponse) {
        detonator.emit(name: "response", value: response)
    }
    
    public struct IncomingRequest: Decodable {
        let id: Int
        let name: String
        let componentId: Int?
        let data: String?
    }
    
    public struct OutgoingResponse: Encodable {
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
