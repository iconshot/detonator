class AttributeHelper {
    static func convertPercentStringToFloat(_ percentString: String) -> Float? {
        let numberString = percentString.replacingOccurrences(of: "%", with: "")
        
        if let value = Float(numberString) {
            return value / 100
        } else {
            return nil
        }
    }
}
