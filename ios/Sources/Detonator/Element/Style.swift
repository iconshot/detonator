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
    // layout
    
    var flex: Int?
    var flexDirection: String?
    var justifyContent: String?
    var alignItems: String?
    var alignSelf: String?
    
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
    var top: Float?
    var left: Float?
    var bottom: Float?
    var right: Float?
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        flex = try container.decodeIfPresent(Int.self, forKey: .flex)
        flexDirection = try container.decodeIfPresent(String.self, forKey: .flexDirection)
        justifyContent = try container.decodeIfPresent(String.self, forKey: .justifyContent)
        alignItems = try container.decodeIfPresent(String.self, forKey: .alignItems)
        backgroundColor = try container.decodeIfPresent(StyleColor.self, forKey: .backgroundColor)
        width = try container.decodeIfPresent(StyleSize.self, forKey: .width)
        height = try container.decodeIfPresent(StyleSize.self, forKey: .height)
        minWidth = try container.decodeIfPresent(StyleSize.self, forKey: .minWidth)
        minHeight = try container.decodeIfPresent(StyleSize.self, forKey: .minHeight)
        maxWidth = try container.decodeIfPresent(StyleSize.self, forKey: .maxWidth)
        maxHeight = try container.decodeIfPresent(StyleSize.self, forKey: .maxHeight)
        padding = try container.decodeIfPresent(Float.self, forKey: .padding)
        paddingHorizontal = try container.decodeIfPresent(Float.self, forKey: .paddingHorizontal)
        paddingVertical = try container.decodeIfPresent(Float.self, forKey: .paddingVertical)
        paddingTop = try container.decodeIfPresent(Float.self, forKey: .paddingTop)
        paddingLeft = try container.decodeIfPresent(Float.self, forKey: .paddingLeft)
        paddingBottom = try container.decodeIfPresent(Float.self, forKey: .paddingBottom)
        paddingRight = try container.decodeIfPresent(Float.self, forKey: .paddingRight)
        margin = try container.decodeIfPresent(Float.self, forKey: .margin)
        marginHorizontal = try container.decodeIfPresent(Float.self, forKey: .marginHorizontal)
        marginVertical = try container.decodeIfPresent(Float.self, forKey: .marginVertical)
        marginTop = try container.decodeIfPresent(Float.self, forKey: .marginTop)
        marginLeft = try container.decodeIfPresent(Float.self, forKey: .marginLeft)
        marginBottom = try container.decodeIfPresent(Float.self, forKey: .marginBottom)
        marginRight = try container.decodeIfPresent(Float.self, forKey: .marginRight)
        fontSize = try container.decodeIfPresent(Float.self, forKey: .fontSize)
        lineHeight = try container.decodeIfPresent(Float.self, forKey: .lineHeight)
        fontWeight = try container.decodeIfPresent(String.self, forKey: .fontWeight)
        color = try container.decodeIfPresent(StyleColor.self, forKey: .color)
        textAlign = try container.decodeIfPresent(String.self, forKey: .textAlign)
        textDecoration = try container.decodeIfPresent(String.self, forKey: .textDecoration)
        textTransform = try container.decodeIfPresent(String.self, forKey: .textTransform)
        textOverflow = try container.decodeIfPresent(String.self, forKey: .textOverflow)
        overflowWrap = try container.decodeIfPresent(String.self, forKey: .overflowWrap)
        wordBreak = try container.decodeIfPresent(String.self, forKey: .wordBreak)
        position = try container.decodeIfPresent(String.self, forKey: .position)
        top = try container.decodeIfPresent(Float.self, forKey: .top)
        left = try container.decodeIfPresent(Float.self, forKey: .left)
        bottom = try container.decodeIfPresent(Float.self, forKey: .bottom)
        right = try container.decodeIfPresent(Float.self, forKey: .right)
        zIndex = try container.decodeIfPresent(Int.self, forKey: .zIndex)
        display = try container.decodeIfPresent(String.self, forKey: .display)
        pointerEvents = try container.decodeIfPresent(String.self, forKey: .pointerEvents)
        objectFit = try container.decodeIfPresent(String.self, forKey: .objectFit)
        overflow = try container.decodeIfPresent(String.self, forKey: .overflow)
        opacity = try container.decodeIfPresent(Float.self, forKey: .opacity)
        aspectRatio = try container.decodeIfPresent(Float.self, forKey: .aspectRatio)
        borderRadius = try container.decodeIfPresent(StyleSize.self, forKey: .borderRadius)
        borderRadiusTopLeft = try container.decodeIfPresent(StyleSize.self, forKey: .borderRadiusTopLeft)
        borderRadiusTopRight = try container.decodeIfPresent(StyleSize.self, forKey: .borderRadiusTopRight)
        borderRadiusBottomLeft = try container.decodeIfPresent(StyleSize.self, forKey: .borderRadiusBottomLeft)
        borderRadiusBottomRight = try container.decodeIfPresent(StyleSize.self, forKey: .borderRadiusBottomRight)
        borderWidth = try container.decodeIfPresent(Float.self, forKey: .borderWidth)
        borderColor = try container.decodeIfPresent(StyleColor.self, forKey: .borderColor)
        borderTopWidth = try container.decodeIfPresent(Float.self, forKey: .borderTopWidth)
        borderTopColor = try container.decodeIfPresent(StyleColor.self, forKey: .borderTopColor)
        borderLeftWidth = try container.decodeIfPresent(Float.self, forKey: .borderLeftWidth)
        borderLeftColor = try container.decodeIfPresent(StyleColor.self, forKey: .borderLeftColor)
        borderBottomWidth = try container.decodeIfPresent(Float.self, forKey: .borderBottomWidth)
        borderBottomColor = try container.decodeIfPresent(StyleColor.self, forKey: .borderBottomColor)
        borderRightWidth = try container.decodeIfPresent(Float.self, forKey: .borderRightWidth)
        borderRightColor = try container.decodeIfPresent(StyleColor.self, forKey: .borderRightColor)
        transform = try container.decodeIfPresent(StyleTransform.self, forKey: .transform)
    }
    
    private enum CodingKeys: String, CodingKey {
        case flex
        case flexDirection
        case justifyContent
        case alignItems
        case backgroundColor
        case width
        case height
        case maxWidth
        case maxHeight
        case minWidth
        case minHeight
        case padding
        case paddingHorizontal
        case paddingVertical
        case paddingTop
        case paddingLeft
        case paddingBottom
        case paddingRight
        case margin
        case marginHorizontal
        case marginVertical
        case marginTop
        case marginLeft
        case marginBottom
        case marginRight
        case fontSize
        case lineHeight
        case fontWeight
        case color
        case textAlign
        case textDecoration
        case textTransform
        case textOverflow
        case overflowWrap
        case wordBreak
        case position
        case top
        case left
        case bottom
        case right
        case zIndex
        case display
        case pointerEvents
        case objectFit
        case overflow
        case opacity
        case aspectRatio
        case borderRadius
        case borderRadiusTopLeft
        case borderRadiusTopRight
        case borderRadiusBottomLeft
        case borderRadiusBottomRight
        case borderWidth
        case borderColor
        case borderTopWidth
        case borderTopColor
        case borderLeftWidth
        case borderLeftColor
        case borderBottomWidth
        case borderBottomColor
        case borderRightWidth
        case borderRightColor
        case transform
    }
}
