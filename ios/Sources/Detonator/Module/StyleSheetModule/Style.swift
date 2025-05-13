public enum StyleColor: Decodable {
    case string(String)
    case array([Float])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([Float].self) {
            self = .array(array)
        } else {
            throw DecodingError.typeMismatch(StyleColor.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or [Float]"))
        }
    }
}

public enum StyleSize: Decodable {
    case float(Float)
    case string(String)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let float = try? container.decode(Float.self) {
            self = .float(float)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.typeMismatch(StyleSize.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Float or String"))
        }
    }
}

public struct StyleTransform: Decodable {
    var translateX: StyleSize?
    var translateY: StyleSize?
    var scale: StyleSize?
    var scaleX: StyleSize?
    var scaleY: StyleSize?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        translateX = try container.decodeIfPresent(StyleSize.self, forKey: .translateX)
        translateY = try container.decodeIfPresent(StyleSize.self, forKey: .translateY)
        scale = try container.decodeIfPresent(StyleSize.self, forKey: .scale)
        scaleX = try container.decodeIfPresent(StyleSize.self, forKey: .scaleX)
        scaleY = try container.decodeIfPresent(StyleSize.self, forKey: .scaleY)
    }
    
    private enum CodingKeys: String, CodingKey {
        case translateX
        case translateY
        case scale
        case scaleX
        case scaleY
    }
}

public struct Style: Decodable {
    // flex
    
    var flex: Int?
    var flexDirection: String?
    var justifyContent: String?
    var alignItems: String?
    var alignSelf: String?
    var gap: Float?
    
    // bg
    
    var backgroundColor: StyleColor?
    
    // size
    
    var width: StyleSize?
    var height: StyleSize?
    var minWidth: StyleSize?
    var minHeight: StyleSize?
    var maxWidth: StyleSize?
    var maxHeight: StyleSize?
    
    // padding
    
    var padding: Float?
    var paddingHorizontal: Float?
    var paddingVertical: Float?
    var paddingTop: Float?
    var paddingLeft: Float?
    var paddingBottom: Float?
    var paddingRight: Float?
    
    // margin
    
    var margin: Float?
    var marginHorizontal: Float?
    var marginVertical: Float?
    var marginTop: Float?
    var marginLeft: Float?
    var marginBottom: Float?
    var marginRight: Float?
    
    // text
    
    var fontSize: Float?
    var lineHeight: Float?
    var fontWeight: String?
    var color: StyleColor?
    var textAlign: String?
    var textDecoration: String?
    var textTransform: String?
    var textOverflow: String?
    var overflowWrap: String?
    var wordBreak: String?
    
    // position
    
    var position: String?
    var top: StyleSize?
    var left: StyleSize?
    var bottom: StyleSize?
    var right: StyleSize?
    var zIndex: Int?
    
    // misc
    
    var display: String?
    var pointerEvents: String?
    var objectFit: String?
    var overflow: String?
    var opacity: Float?
    var aspectRatio: Float?
    
    // border radius
    
    var borderRadius: StyleSize?
    var borderRadiusTopLeft: StyleSize?
    var borderRadiusTopRight: StyleSize?
    var borderRadiusBottomLeft: StyleSize?
    var borderRadiusBottomRight: StyleSize?
    
    // border
    
    var borderWidth: Float?
    var borderColor: StyleColor?
    
    var borderTopWidth: Float?
    var borderTopColor: StyleColor?
    
    var borderLeftWidth: Float?
    var borderLeftColor: StyleColor?
    
    var borderBottomWidth: Float?
    var borderBottomColor: StyleColor?
    
    var borderRightWidth: Float?
    var borderRightColor: StyleColor?
    
    // transform
    
    var transform: StyleTransform?
}
