import Foundation

public class MessageFormatter {
    private let detonator: Detonator
    
    private static let delimiter = "\u{0000}"

    init(_ detonator: Detonator) {
        self.detonator = detonator
    }

    public func join(_ lines: [Encodable?]) -> String {
        var parts: [String] = []

        for line in lines {
            if let str = line as? String {
                parts.append(str)
            } else {
                parts.append(detonator.encode(line)!)
            }
        }

        return parts.joined(separator: Self.delimiter)
    }

    public func split(_ value: String, _ limit: Int = 0) -> [String] {
        let parts = value.components(separatedBy: Self.delimiter)
        
        if limit == 0 {
            return parts
        }
        
        if parts.count <= limit {
            return parts
        }
        
        let head = parts.prefix(limit - 1)
        let tail = parts.suffix(from: limit - 1).joined(separator: Self.delimiter)
        
        return Array(head) + [tail]
    }
}
