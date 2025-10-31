import Foundation

public class RequestPromise {
    private let detonator: Detonator
    private let fetchId: Int
    
    init(_ detonator: Detonator, _ fetchId: Int) {
        self.detonator = detonator
        self.fetchId = fetchId
    }
    
    public func resolve(_ data: Encodable? = "") -> Void {
        let lines: [Encodable?] = [fetchId, data]
        
        let value = detonator.messageFormatter.join(lines)
        
        DispatchQueue.main.async {
            self.detonator.send("com.iconshot.detonator.request.fetch::resolve", value)
        }
    }
    
    public func reject(_ error: Error) -> Void {
        reject(error.localizedDescription)
    }
    
    public func reject(_ message: String) -> Void {
        let lines: [Encodable?] = [fetchId, message]
        
        let value = detonator.messageFormatter.join(lines)
        
        DispatchQueue.main.async {
            self.detonator.send("com.iconshot.detonator.request.fetch::reject", value)
        }
    }
}
