public struct NullEncodable<T: Encodable>: Encodable {
    private var value: T?

    public init(_ value: T?) {
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let value = value {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}
