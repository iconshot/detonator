public class StyleEntry: Decodable {
    public var style: Style
    public var keys: [String]
    
    init(style: Style, keys: [String]) {
        self.style = style
        self.keys = keys
    }
}
