public class AttributeHelper {
    public static func convertPercentStringToFloat(_ percentString: String) -> Float? {
        let numberString = percentString.replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if let value = Float(numberString) {
            let percent = value / 100
            
            return percentString.starts(with: "-") ? percent * -1 : percent
        } else {
            return nil
        }
    }
}
