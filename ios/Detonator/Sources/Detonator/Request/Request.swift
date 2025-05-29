import UIKit

open class Request {
    public let detonator: Detonator
    
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
    
    open func run() {}
    
    public func end(data: Encodable? = nil) {
        let response = OutgoingResponse(id: id, data: data, error: nil)
        
        emitResponse(response: response)
    }
    
    public func error(message: String) {
        let tmpError = OutgoingResponse.Error(message: message)
        
        let response = OutgoingResponse(id: id, data: nil, error: tmpError)
        
        emitResponse(response: response)
    }
    
    public func error(error: Error) {
        self.error(message: error.localizedDescription)
    }
    
    private func emitResponse(response: OutgoingResponse) {
        detonator.emit("com.iconshot.detonator.request.response", response)
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
