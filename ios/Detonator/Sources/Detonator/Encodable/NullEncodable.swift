struct NullEncodable<T: Encodable>: Encodable {
    var value: T?

    init(_ value: T?) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let value = value {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}
