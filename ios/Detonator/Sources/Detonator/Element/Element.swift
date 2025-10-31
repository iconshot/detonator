import UIKit

public enum AttributesStyle: Decodable {
    case string(String)
    case int(Int)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode(Int.self) {
            self = .int(array)
        } else {
            throw DecodingError.typeMismatch(AttributesStyle.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Int"))
        }
    }
}

open class Attributes: Decodable {
    public let style: [AttributesStyle?]?
    public let onTap: Bool?
    public let onLongTap: Bool?
    public let onDoubleTap: Bool?
}

open class Element: NSObject {
    public let detonator: Detonator
    
    public var edge: Edge!
    
    public var view: UIView!
    
    public var attributes: Attributes!
    public var prevAttributes: Attributes?
    
    private var styleEntries: [StyleEntry]!
    private var prevStyleEntries: [StyleEntry]?
    
    private var additionalStyleEntry: StyleEntry?
    
    public var forcePatch: Bool = true
    
    private var requestListeners: [String: ((RequestPromise, String) -> Void)] = [:]
    
    public var tapGestureRecognizer: UITapGestureRecognizer!
    public var longTapGestureRecognizer: UILongPressGestureRecognizer!
    
    required public init(_ detonator: Detonator) {
        self.detonator = detonator
        
        super.init()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapListener(_:)))
        longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongTapListener(_:)))
    }
    
    public func decodeAttributes<T: Attributes>() -> T {
        return detonator.decode(edge.attributes!)!
    }
    
    open func decodeAttributes() -> Attributes? {
        preconditionFailure("This method must be overridden.")
    }
    
    public func setRequestListener(_ name: String, _ listener: @escaping (RequestPromise, String) -> Void) {
        requestListeners[name] = listener
    }
    
    public func getRequestListener(_ name: String) -> ((RequestPromise, String) -> Void)? {
        return requestListeners[name]
    }
    
    public func sendHandler(name: String, data: Encodable? = nil) {
        let handler = Handler(name: name, edgeId: edge.id, data: data)
        
        detonator.send("com.iconshot.detonator.handler", handler)
    }
    
    public func create() -> Void {
        let view = createView()
        
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(longTapGestureRecognizer)
        
        self.view = view
    }
    
    public func patch() -> Void {
        prevAttributes = attributes
        prevStyleEntries = styleEntries
        
        attributes = decodeAttributes()
        
        styleEntries = []
        
        if attributes.style != nil {
            for tmpStyle in attributes.style! {
                switch tmpStyle {
                case .int(let int):
                    let styleEntryId = int
                    
                    let styleEntry = StyleSheetModule.styleEntries[styleEntryId]!
                    
                    styleEntries.append(styleEntry)
                    
                    break
                    
                case .string(let string):
                    let styleEntry: StyleEntry = detonator.decode(string)!
                    
                    styleEntries.append(styleEntry)
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
        let style = createStyle(styleEntries: styleEntries)
        
        let prevStyle = prevStyleEntries != nil ? createStyle(styleEntries: prevStyleEntries!) : nil
        
        let styler = Styler(style: style)
        let prevStyler = Styler(style: prevStyle)
        
        patchStyler(styler: styler, prevStyler: prevStyler)
        
        patchView()
        
        forcePatch = false
    }
    
    private func patchStyler(styler: Styler, prevStyler: Styler) -> Void {
        let flex = styler.getFlex()
        let flexDirection = styler.getFlexDirection()
        let justifyContent = styler.getJustifyContent()
        let alignItems = styler.getAlignItems()
        let alignSelf = styler.getAlignSelf()
        let gap = styler.getGap()
        let backgroundColor = styler.getBackgroundColor()
        let width = styler.getWidth()
        let height = styler.getHeight()
        let minWidth = styler.getMinWidth()
        let minHeight = styler.getMinHeight()
        let maxWidth = styler.getMaxWidth()
        let maxHeight = styler.getMaxHeight()
        let padding = styler.getPadding()
        let paddingHorizontal = styler.getPaddingHorizontal()
        let paddingVertical = styler.getPaddingVertical()
        let paddingTop = styler.getPaddingTop()
        let paddingLeft = styler.getPaddingLeft()
        let paddingBottom = styler.getPaddingBottom()
        let paddingRight = styler.getPaddingRight()
        let margin = styler.getMargin()
        let marginHorizontal = styler.getMarginHorizontal()
        let marginVertical = styler.getMarginVertical()
        let marginTop = styler.getMarginTop()
        let marginLeft = styler.getMarginLeft()
        let marginBottom = styler.getMarginBottom()
        let marginRight = styler.getMarginRight()
        let fontSize = styler.getFontSize()
        let lineHeight = styler.getLineHeight()
        let fontWeight = styler.getFontWeight()
        let color = styler.getColor()
        let textAlign = styler.getTextAlign()
        let textDecoration = styler.getTextDecoration()
        let textTransform = styler.getTextTransform()
        let textOverflow = styler.getTextOverflow()
        let overflowWrap = styler.getOverflowWrap()
        let wordBreak = styler.getWordBreak()
        let position = styler.getPosition()
        let top = styler.getTop()
        let left = styler.getLeft()
        let bottom = styler.getBottom()
        let right = styler.getRight()
        let zIndex = styler.getZIndex()
        let display = styler.getDisplay()
        let pointerEvents = styler.getPointerEvents()
        let objectFit = styler.getObjectFit()
        let overflow = styler.getOverflow()
        let opacity = styler.getOpacity()
        let aspectRatio = styler.getAspectRatio()
        let borderRadius = styler.getBorderRadius()
        let borderRadiusTopLeft = styler.getBorderRadiusTopLeft()
        let borderRadiusTopRight = styler.getBorderRadiusTopRight()
        let borderRadiusBottomLeft = styler.getBorderRadiusBottomLeft()
        let borderRadiusBottomRight = styler.getBorderRadiusBottomRight()
        let borderWidth = styler.getBorderWidth()
        let borderColor = styler.getBorderColor()
        let borderTopWidth = styler.getBorderTopWidth()
        let borderTopColor = styler.getBorderTopColor()
        let borderLeftWidth = styler.getBorderLeftWidth()
        let borderLeftColor = styler.getBorderLeftColor()
        let borderBottomWidth = styler.getBorderBottomWidth()
        let borderBottomColor = styler.getBorderBottomColor()
        let borderRightWidth = styler.getBorderRightWidth()
        let borderRightColor = styler.getBorderRightColor()
        let transform = styler.getTransform()
        
        let prevFlex = prevStyler.getFlex()
        let prevFlexDirection = prevStyler.getFlexDirection()
        let prevJustifyContent = prevStyler.getJustifyContent()
        let prevAlignItems = prevStyler.getAlignItems()
        let prevAlignSelf = prevStyler.getAlignSelf()
        let prevGap = prevStyler.getGap()
        let prevBackgroundColor = prevStyler.getBackgroundColor()
        let prevWidth = prevStyler.getWidth()
        let prevHeight = prevStyler.getHeight()
        let prevMinWidth = prevStyler.getMinWidth()
        let prevMinHeight = prevStyler.getMinHeight()
        let prevMaxWidth = prevStyler.getMaxWidth()
        let prevMaxHeight = prevStyler.getMaxHeight()
        let prevPadding = prevStyler.getPadding()
        let prevPaddingHorizontal = prevStyler.getPaddingHorizontal()
        let prevPaddingVertical = prevStyler.getPaddingVertical()
        let prevPaddingTop = prevStyler.getPaddingTop()
        let prevPaddingLeft = prevStyler.getPaddingLeft()
        let prevPaddingBottom = prevStyler.getPaddingBottom()
        let prevPaddingRight = prevStyler.getPaddingRight()
        let prevMargin = prevStyler.getMargin()
        let prevMarginHorizontal = prevStyler.getMarginHorizontal()
        let prevMarginVertical = prevStyler.getMarginVertical()
        let prevMarginTop = prevStyler.getMarginTop()
        let prevMarginLeft = prevStyler.getMarginLeft()
        let prevMarginBottom = prevStyler.getMarginBottom()
        let prevMarginRight = prevStyler.getMarginRight()
        let prevFontSize = prevStyler.getFontSize()
        let prevLineHeight = prevStyler.getLineHeight()
        let prevFontWeight = prevStyler.getFontWeight()
        let prevColor = prevStyler.getColor()
        let prevTextAlign = prevStyler.getTextAlign()
        let prevTextDecoration = prevStyler.getTextDecoration()
        let prevTextTransform = prevStyler.getTextTransform()
        let prevTextOverflow = prevStyler.getTextOverflow()
        let prevOverflowWrap = prevStyler.getOverflowWrap()
        let prevWordBreak = prevStyler.getWordBreak()
        let prevPosition = prevStyler.getPosition()
        let prevTop = prevStyler.getTop()
        let prevLeft = prevStyler.getLeft()
        let prevBottom = prevStyler.getBottom()
        let prevRight = prevStyler.getRight()
        let prevZIndex = prevStyler.getZIndex()
        let prevDisplay = prevStyler.getDisplay()
        let prevPointerEvents = prevStyler.getPointerEvents()
        let prevObjectFit = prevStyler.getObjectFit()
        let prevOverflow = prevStyler.getOverflow()
        let prevOpacity = prevStyler.getOpacity()
        let prevAspectRatio = prevStyler.getAspectRatio()
        let prevBorderRadius = prevStyler.getBorderRadius()
        let prevBorderRadiusTopLeft = prevStyler.getBorderRadiusTopLeft()
        let prevBorderRadiusTopRight = prevStyler.getBorderRadiusTopRight()
        let prevBorderRadiusBottomLeft = prevStyler.getBorderRadiusBottomLeft()
        let prevBorderRadiusBottomRight = prevStyler.getBorderRadiusBottomRight()
        let prevBorderWidth = prevStyler.getBorderWidth()
        let prevBorderColor = prevStyler.getBorderColor()
        let prevBorderTopWidth = prevStyler.getBorderTopWidth()
        let prevBorderTopColor = prevStyler.getBorderTopColor()
        let prevBorderLeftWidth = prevStyler.getBorderLeftWidth()
        let prevBorderLeftColor = prevStyler.getBorderLeftColor()
        let prevBorderBottomWidth = prevStyler.getBorderBottomWidth()
        let prevBorderBottomColor = prevStyler.getBorderBottomColor()
        let prevBorderRightWidth = prevStyler.getBorderRightWidth()
        let prevBorderRightColor = prevStyler.getBorderRightColor()
        let prevTransform = prevStyler.getTransform()
        
        let patchFlexBool = forcePatch || flex != prevFlex
        let patchFlexDirectionBool = forcePatch || flexDirection != prevFlexDirection
        let patchJustifyContentBool = forcePatch || justifyContent != prevJustifyContent
        let patchAlignItemsBool = forcePatch || alignItems != prevAlignItems
        let patchAlignSelfBool = forcePatch || alignSelf != prevAlignSelf
        let patchGapBool = forcePatch || gap != prevGap
        let patchBackgroundColorBool = forcePatch || !CompareHelper.compareStyleColors(backgroundColor, prevBackgroundColor)
        let patchWidthBool = forcePatch || !CompareHelper.compareStyleSizes(width, prevWidth)
        let patchHeightBool = forcePatch || !CompareHelper.compareStyleSizes(height, prevHeight)
        let patchMinWidthBool = forcePatch || !CompareHelper.compareStyleSizes(minWidth, prevMinWidth)
        let patchMinHeightBool = forcePatch || !CompareHelper.compareStyleSizes(minHeight, prevMinHeight)
        let patchMaxWidthBool = forcePatch || !CompareHelper.compareStyleSizes(maxWidth, prevMaxWidth)
        let patchMaxHeightBool = forcePatch || !CompareHelper.compareStyleSizes(maxHeight, prevMaxHeight)
        let patchPaddingBool = forcePatch || padding != prevPadding
        let patchPaddingHorizontalBool = forcePatch || paddingHorizontal != prevPaddingHorizontal
        let patchPaddingVerticalBool = forcePatch || paddingVertical != prevPaddingVertical
        let patchPaddingTopBool = forcePatch || paddingTop != prevPaddingTop
        let patchPaddingLeftBool = forcePatch || paddingLeft != prevPaddingLeft
        let patchPaddingBottomBool = forcePatch || paddingBottom != prevPaddingBottom
        let patchPaddingRightBool = forcePatch || paddingRight != prevPaddingRight
        let patchMarginBool = forcePatch || margin != prevMargin
        let patchMarginHorizontalBool = forcePatch || marginHorizontal != prevMarginHorizontal
        let patchMarginVerticalBool = forcePatch || marginVertical != prevMarginVertical
        let patchMarginTopBool = forcePatch || marginTop != prevMarginTop
        let patchMarginLeftBool = forcePatch || marginLeft != prevMarginLeft
        let patchMarginBottomBool = forcePatch || marginBottom != prevMarginBottom
        let patchMarginRightBool = forcePatch || marginRight != prevMarginRight
        let patchFontSizeBool = forcePatch || fontSize != prevFontSize
        let patchLineHeightBool = forcePatch || lineHeight != prevLineHeight
        let patchFontWeightBool = forcePatch || fontWeight != prevFontWeight
        let patchColorBool = forcePatch || !CompareHelper.compareStyleColors(color, prevColor)
        let patchTextAlignBool = forcePatch || textAlign != prevTextAlign
        let patchTextDecorationBool = forcePatch || textDecoration != prevTextDecoration
        let patchTextTransformBool = forcePatch || textTransform != prevTextTransform
        let patchTextOverflowBool = forcePatch || textOverflow != prevTextOverflow
        let patchOverflowWrapBool = forcePatch || overflowWrap != prevOverflowWrap
        let patchWordBreakBool = forcePatch || wordBreak != prevWordBreak
        let patchPositionBool = forcePatch || position != prevPosition
        let patchTopBool = forcePatch || !CompareHelper.compareStyleSizes(top, prevTop)
        let patchLeftBool = forcePatch || !CompareHelper.compareStyleSizes(left, prevLeft)
        let patchBottomBool = forcePatch || !CompareHelper.compareStyleSizes(bottom, prevBottom)
        let patchRightBool = forcePatch || !CompareHelper.compareStyleSizes(right, prevRight)
        let patchZIndexBool = forcePatch || zIndex != prevZIndex
        let patchDisplayBool = forcePatch || display != prevDisplay
        let patchPointerEventsBool = forcePatch || pointerEvents != prevPointerEvents
        let patchObjectFitBool = forcePatch || objectFit != prevObjectFit
        let patchOverflowBool = forcePatch || overflow != prevOverflow
        let patchOpacityBool = forcePatch || opacity != prevOpacity
        let patchAspectRatioBool = forcePatch || aspectRatio != prevAspectRatio
        let patchBorderRadiusBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadius, prevBorderRadius)
        let patchBorderRadiusTopLeftBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadiusTopLeft, prevBorderRadiusTopLeft)
        let patchBorderRadiusTopRightBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadiusTopRight, prevBorderRadiusTopRight)
        let patchBorderRadiusBottomLeftBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadiusBottomLeft, prevBorderRadiusBottomLeft)
        let patchBorderRadiusBottomRightBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadiusBottomRight, prevBorderRadiusBottomRight)
        let patchBorderWidthBool = forcePatch || borderWidth != prevBorderWidth
        let patchBorderColorBool = forcePatch || !CompareHelper.compareStyleColors(borderColor, prevBorderColor)
        let patchBorderTopWidthBool = forcePatch || borderTopWidth != prevBorderTopWidth
        let patchBorderTopColorBool = forcePatch || !CompareHelper.compareStyleColors(borderTopColor, prevBorderTopColor)
        let patchBorderLeftWidthBool = forcePatch || borderLeftWidth != prevBorderLeftWidth
        let patchBorderLeftColorBool = forcePatch || !CompareHelper.compareStyleColors(borderLeftColor, prevBorderLeftColor)
        let patchBorderBottomWidthBool = forcePatch || borderBottomWidth != prevBorderBottomWidth
        let patchBorderBottomColorBool = forcePatch || !CompareHelper.compareStyleColors(borderBottomColor, prevBorderBottomColor)
        let patchBorderRightWidthBool = forcePatch || borderRightWidth != prevBorderRightWidth
        let patchBorderRightColorBool = forcePatch || !CompareHelper.compareStyleColors(borderRightColor, prevBorderRightColor)
        let patchTransformBool = forcePatch || !CompareHelper.compareStyleTransforms(transform, prevTransform)
        
        if patchFlexBool {
            patchFlex(flex: flex)
        }
        
        if patchFlexDirectionBool {
            patchFlexDirection(flexDirection: flexDirection)
        }

        if patchJustifyContentBool {
            patchJustifyContent(justifyContent: justifyContent)
        }

        if patchAlignItemsBool {
            patchAlignItems(alignItems: alignItems)
        }

        if patchAlignSelfBool {
            patchAlignSelf(alignSelf: alignSelf)
        }
        
        if patchGapBool {
            patchGap(gap: gap)
        }

        if patchBackgroundColorBool {
            patchBackgroundColor(backgroundColor: backgroundColor)
        }
        
        if patchWidthBool {
            patchWidth(width: width)
        }

        if patchHeightBool {
            patchHeight(height: height)
        }

        if patchMinWidthBool {
            patchMinWidth(minWidth: minWidth)
        }

        if patchMinHeightBool {
            patchMinHeight(minHeight: minHeight)
        }

        if patchMaxWidthBool {
            patchMaxWidth(maxWidth: maxWidth)
        }

        if patchMaxHeightBool {
            patchMaxHeight(maxHeight: maxHeight)
        }
        
        if patchPaddingBool
            || patchPaddingHorizontalBool
            || patchPaddingVerticalBool
            || patchPaddingTopBool
            || patchPaddingLeftBool
            || patchPaddingBottomBool
            || patchPaddingRightBool {
            patchPadding(
                padding: padding,
                paddingHorizontal: paddingHorizontal,
                paddingVertical: paddingVertical,
                paddingTop: paddingTop,
                paddingLeft: paddingLeft,
                paddingBottom: paddingBottom,
                paddingRight: paddingRight
            )
        }

        if patchMarginBool
            || patchMarginHorizontalBool
            || patchMarginVerticalBool
            || patchMarginTopBool
            || patchMarginLeftBool
            || patchMarginBottomBool
            || patchMarginRightBool {
            patchMargin(
                margin: margin,
                marginHorizontal: marginHorizontal,
                marginVertical: marginVertical,
                marginTop: marginTop,
                marginLeft: marginLeft,
                marginBottom: marginBottom,
                marginRight: marginRight
            )
        }

        if patchFontSizeBool {
            patchFontSize(fontSize: fontSize)
        }

        if patchLineHeightBool {
            patchLineHeight(lineHeight: lineHeight)
        }

        if patchFontWeightBool {
            patchFontWeight(fontWeight: fontWeight)
        }

        if patchColorBool {
            patchColor(color: color)
        }

        if patchTextAlignBool {
            patchTextAlign(textAlign: textAlign)
        }

        if patchTextDecorationBool {
            patchTextDecoration(textDecoration: textDecoration)
        }

        if patchTextTransformBool {
            patchTextTransform(textTransform: textTransform)
        }

        if patchTextOverflowBool {
            patchTextOverflow(textOverflow: textOverflow)
        }

        if patchOverflowWrapBool {
            patchOverflowWrap(overflowWrap: overflowWrap)
        }

        if patchWordBreakBool {
            patchWordBreak(wordBreak: wordBreak)
        }

        if patchPositionBool {
            patchPosition(position: position)
        }

        if patchTopBool {
            patchTop(top: top)
        }

        if patchLeftBool {
            patchLeft(left: left)
        }

        if patchBottomBool {
            patchBottom(bottom: bottom)
        }

        if patchRightBool {
            patchRight(right: right)
        }

        if patchZIndexBool {
            patchZIndex(zIndex: zIndex)
        }
    
        
        if patchDisplayBool {
            patchDisplay(display: display)
        }

        if patchPointerEventsBool {
            patchPointerEvents(pointerEvents: pointerEvents)
        }

        if patchObjectFitBool {
            patchObjectFit(objectFit: objectFit)
        }

        if patchOverflowBool {
            patchOverflow(overflow: overflow)
        }

        if patchOpacityBool {
            patchOpacity(opacity: opacity)
        }

        if patchAspectRatioBool {
            patchAspectRatio(aspectRatio: aspectRatio)
        }

        if patchBorderRadiusBool
            || patchBorderRadiusTopLeftBool
            || patchBorderRadiusTopRightBool
            || patchBorderRadiusBottomLeftBool
            || patchBorderRadiusBottomRightBool {
            patchBorderRadius(
                borderRadius: borderRadius,
                borderRadiusTopLeft: borderRadiusTopLeft,
                borderRadiusTopRight: borderRadiusTopRight,
                borderRadiusBottomLeft: borderRadiusBottomLeft,
                borderRadiusBottomRight: borderRadiusBottomRight
            )
        }

        if patchBorderWidthBool {
            patchBorderWidth(borderWidth: borderWidth)
        }

        if patchBorderColorBool {
            patchBorderColor(borderColor: borderColor)
        }

        if patchBorderTopWidthBool {
            patchBorderTopWidth(borderTopWidth: borderTopWidth)
        }

        if patchBorderTopColorBool {
            patchBorderTopColor(borderTopColor: borderTopColor)
        }

        if patchBorderLeftWidthBool {
            patchBorderLeftWidth(borderLeftWidth: borderLeftWidth)
        }

        if patchBorderLeftColorBool {
            patchBorderLeftColor(borderLeftColor: borderLeftColor)
        }

        if patchBorderBottomWidthBool {
            patchBorderBottomWidth(borderBottomWidth: borderBottomWidth)
        }

        if patchBorderBottomColorBool {
            patchBorderBottomColor(borderBottomColor: borderBottomColor)
        }

        if patchBorderRightWidthBool {
            patchBorderRightWidth(borderRightWidth: borderRightWidth)
        }

        if patchBorderRightColorBool {
            patchBorderRightColor(borderRightColor: borderRightColor)
        }
        
        if patchTransformBool {
            patchTransform(transform: transform)
        }
    }
    
    open func patchFlex(flex: Int?) {
        let layoutParams = view.layoutParams
        
        layoutParams.flex = flex
    }

    open func patchFlexDirection(flexDirection: String?) {
    }

    open func patchJustifyContent(justifyContent: String?) {
    }

    open func patchAlignItems(alignItems: String?) {
    }

    open func patchAlignSelf(alignSelf: String?) {
        let layoutParams = view.layoutParams
        
        switch alignSelf {
        case "flex-start":
            layoutParams.alignSelf = .flexStart
            
            break
            
        case "flex-end":
            layoutParams.alignSelf = .flexEnd
            
            break
            
        case "start":
            layoutParams.alignSelf = .start
            
            break
            
        case "end":
            layoutParams.alignSelf = .end
            
            break
            
        case "center":
            layoutParams.alignSelf = .center
            
            break
            
        default:
            layoutParams.alignSelf = nil
            
            break
        }
    }
    
    open func patchGap(gap: Float?) -> Void {
    }

    open func patchBackgroundColor(backgroundColor: StyleColor?) -> Void {
        let tmpBackgroundColor = backgroundColor != nil ? ColorHelper.parseColor(color: backgroundColor!) : nil
                    
        view.backgroundColor = tmpBackgroundColor ?? UIColor.clear
    }

    open func patchWidth(width: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch width {
        case .float(let float):
            layoutParams.width = float
            layoutParams.widthPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.width = nil
            layoutParams.widthPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.width = nil
            layoutParams.widthPercent = nil
            
            break
        }
    }

    open func patchHeight(height: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch height {
        case .float(let float):
           layoutParams.height = float
           layoutParams.heightPercent = nil
           
           break

        case .string(let string):
           layoutParams.height = nil
           layoutParams.heightPercent = AttributeHelper.convertPercentStringToFloat(string)
           
           break
           
        default:
           layoutParams.height = nil
           layoutParams.heightPercent = nil
           
           break
        }
    }

    open func patchMinWidth(minWidth: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch minWidth {
        case .float(let float):
            layoutParams.minWidth = float
            layoutParams.minWidthPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.minWidth = nil
            layoutParams.minWidthPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.minWidth = nil
            layoutParams.minWidthPercent = nil
            
            break
        }
    }

    open func patchMinHeight(minHeight: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch minHeight {
        case .float(let float):
            layoutParams.minHeight = float
            layoutParams.minHeightPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.minHeight = nil
            layoutParams.minHeightPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.minHeight = nil
            layoutParams.minHeightPercent = nil
            
            break
        }
    }

    open func patchMaxWidth(maxWidth: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch maxWidth {
        case .float(let float):
            layoutParams.maxWidth = float
            layoutParams.maxWidthPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.maxWidth = nil
            layoutParams.maxWidthPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.maxWidth = nil
            layoutParams.maxWidthPercent = nil
            
            break
        }
    }

    open func patchMaxHeight(maxHeight: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch maxHeight {
        case .float(let float):
            layoutParams.maxHeight = float
            layoutParams.maxHeightPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.maxHeight = nil
            layoutParams.maxHeightPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.maxHeight = nil
            layoutParams.maxHeightPercent = nil
            
            break
        }
    }

    open func patchPadding(
        padding: Float?,
        paddingHorizontal: Float?,
        paddingVertical: Float?,
        paddingTop: Float?,
        paddingLeft: Float?,
        paddingBottom: Float?,
        paddingRight: Float?
    ) -> Void {
        let layoutParams = view.layoutParams
        
        let tmpPadding = padding ?? 0
        
        var tmpPaddingTop = tmpPadding
        var tmpPaddingLeft = tmpPadding
        var tmpPaddingBottom = tmpPadding
        var tmpPaddingRight = tmpPadding
        
        if paddingHorizontal != nil {
            tmpPaddingLeft = paddingHorizontal!
            tmpPaddingRight = paddingHorizontal!
        }
        
        if paddingVertical != nil {
            tmpPaddingTop = paddingVertical!
            tmpPaddingBottom = paddingVertical!
        }
        
        if paddingTop != nil {
            tmpPaddingTop = paddingTop!
        }
        
        if paddingLeft != nil {
            tmpPaddingLeft = paddingLeft!
        }
        
        if paddingBottom != nil {
            tmpPaddingBottom = paddingBottom!
        }
        
        if paddingRight != nil {
            tmpPaddingRight = paddingRight!
        }
        
        layoutParams.padding.top = tmpPaddingTop
        layoutParams.padding.left = tmpPaddingLeft
        layoutParams.padding.bottom = tmpPaddingBottom
        layoutParams.padding.right = tmpPaddingRight
    }

    open func patchMargin(
        margin: Float?,
        marginHorizontal: Float?,
        marginVertical: Float?,
        marginTop: Float?,
        marginLeft: Float?,
        marginBottom: Float?,
        marginRight: Float?
    ) -> Void {
        let layoutParams = view.layoutParams

        let tmpMargin = margin ?? 0

        var tmpMarginTop = tmpMargin
        var tmpMarginLeft = tmpMargin
        var tmpMarginBottom = tmpMargin
        var tmpMarginRight = tmpMargin

        if marginHorizontal != nil {
            tmpMarginLeft = marginHorizontal!
            tmpMarginRight = marginHorizontal!
        }

        if marginVertical != nil {
            tmpMarginTop = marginVertical!
            tmpMarginBottom = marginVertical!
        }
        
        if marginTop != nil {
            tmpMarginTop = marginTop!
        }
        
        if marginLeft != nil {
            tmpMarginLeft = marginLeft!
        }
        
        if marginBottom != nil {
            tmpMarginBottom = marginBottom!
        }
        
        if marginRight != nil {
            tmpMarginRight = marginRight!
        }

        layoutParams.margin.top = tmpMarginTop
        layoutParams.margin.left = tmpMarginLeft
        layoutParams.margin.bottom = tmpMarginBottom
        layoutParams.margin.right = tmpMarginRight
    }

    open func patchFontSize(fontSize: Float?) -> Void {
    }

    open func patchLineHeight(lineHeight: Float?) -> Void {
    }

    open func patchFontWeight(fontWeight: String?) -> Void {
    }

    open func patchColor(color: StyleColor?) -> Void {
    }

    open func patchTextAlign(textAlign: String?) -> Void {
    }

    open func patchTextDecoration(textDecoration: String?) -> Void {
    }

    open func patchTextTransform(textTransform: String?) -> Void {
    }

    open func patchTextOverflow(textOverflow: String?) -> Void {
    }

    open func patchOverflowWrap(overflowWrap: String?) -> Void {
    }

    open func patchWordBreak(wordBreak: String?) -> Void {
    }

    open func patchPosition(position: String?) -> Void {
        let layoutParams = view.layoutParams
        
        switch position {
        case "absolute":
            layoutParams.position = .absolute
            
            break
            
        default:
            layoutParams.position = .relative
            
            break
        }
    }

    open func patchTop(top: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch top {
        case .float(let float):
            layoutParams.positionTop = float
            layoutParams.positionTopPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.positionTop = nil
            layoutParams.positionTopPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.positionTop = nil
            layoutParams.positionTopPercent = nil
            
            break
        }
    }

    open func patchLeft(left: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch left {
        case .float(let float):
            layoutParams.positionLeft = float
            layoutParams.positionLeftPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.positionLeft = nil
            layoutParams.positionLeftPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.positionLeft = nil
            layoutParams.positionLeftPercent = nil
            
            break
        }
    }

    open func patchBottom(bottom: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch bottom {
        case .float(let float):
            layoutParams.positionBottom = float
            layoutParams.positionBottomPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.positionBottom = nil
            layoutParams.positionBottomPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.positionBottom = nil
            layoutParams.positionBottomPercent = nil
            
            break
        }
    }

    open func patchRight(right: StyleSize?) -> Void {
        let layoutParams = view.layoutParams
        
        switch right {
        case .float(let float):
            layoutParams.positionRight = float
            layoutParams.positionRightPercent = nil
            
            break
        
        case .string(let string):
            layoutParams.positionRight = nil
            layoutParams.positionRightPercent = AttributeHelper.convertPercentStringToFloat(string)
            
            break
            
        default:
            layoutParams.positionRight = nil
            layoutParams.positionRightPercent = nil
            
            break
        }
    }

    open func patchZIndex(zIndex: Int?) -> Void {
        view.layer.zPosition = zIndex != nil ? CGFloat(zIndex!) : 0
    }

    open func patchDisplay(display: String?) -> Void {
        let layoutParams = view.layoutParams
        
        switch display {
        case "none":
            layoutParams.display = .none
            
            resignFirstResponder(view)
            
            view.isHidden = true
            
            break
            
        default:
            layoutParams.display = .flex
            
            view.isHidden = false
            
            break
        }
    }

    open func patchPointerEvents(pointerEvents: String?) -> Void {
    }

    open func patchObjectFit(objectFit: String?) -> Void {
    }

    open func patchOverflow(overflow: String?) -> Void {
    }

    open func patchOpacity(opacity: Float?) -> Void {
        view.alpha = opacity != nil ? CGFloat(opacity!) : 1.0
    }

    open func patchAspectRatio(aspectRatio: Float?) -> Void {
        let layoutParams = view.layoutParams
        
        layoutParams.aspectRatio = aspectRatio
    }

    open func patchBorderRadius(
        borderRadius: StyleSize?,
        borderRadiusTopLeft: StyleSize?,
        borderRadiusTopRight: StyleSize?,
        borderRadiusBottomLeft: StyleSize?,
        borderRadiusBottomRight: StyleSize?
    ) -> Void {
        let layoutParams = view.layoutParams
        
        layoutParams.onLayoutClosures["borderRadius"] = {
            self.view.layer.mask = nil
            
            let width = self.view.frame.size.width
            let height = self.view.frame.size.height
            
            let tmpBorderRadius = self.convertBorderRadius(size: borderRadius, width: width, height: height)
            
            let tmpBorderRadiusTopLeft = borderRadiusTopLeft != nil
            ? self.convertBorderRadius(size: borderRadiusTopLeft!, width: width, height: height)
            : tmpBorderRadius
            
            let tmpBorderRadiusTopRight = borderRadiusTopRight != nil
            ? self.convertBorderRadius(size: borderRadiusTopRight!, width: width, height: height)
            : tmpBorderRadius
            
            let tmpBorderRadiusBottomLeft = borderRadiusBottomLeft != nil
            ? self.convertBorderRadius(size: borderRadiusBottomLeft!, width: width, height: height)
            : tmpBorderRadius
            
            let tmpBorderRadiusBottomRight = borderRadiusBottomRight != nil
            ? self.convertBorderRadius(size: borderRadiusBottomRight!, width: width, height: height)
            : tmpBorderRadius
            
            let path = UIBezierPath()
            
            // start at top-left corner
            
            path.move(to: CGPoint(x: tmpBorderRadiusTopLeft, y: 0))
                
            // top-right corner
            
            path.addLine(to: CGPoint(x: width - tmpBorderRadiusTopRight, y: 0))
            
            path.addArc(
                withCenter: CGPoint(x: width - tmpBorderRadiusTopRight, y: tmpBorderRadiusTopRight),
                radius: tmpBorderRadiusTopRight,
                startAngle: CGFloat(3 * Double.pi / 2),
                endAngle: 0,
                clockwise: true
            )
            
            // bottom-right corner

            path.addLine(to: CGPoint(x: width, y: height - tmpBorderRadiusBottomRight))
            
            path.addArc(
                withCenter: CGPoint(x: width - tmpBorderRadiusBottomRight, y: height - tmpBorderRadiusBottomRight),
                radius: tmpBorderRadiusBottomRight,
                startAngle: 0,
                endAngle: CGFloat(Double.pi / 2),
                clockwise: true
            )
            
            // bottom-left corner
        
            path.addLine(to: CGPoint(x: tmpBorderRadiusBottomLeft, y: height))
            
            path.addArc(
                withCenter: CGPoint(x: tmpBorderRadiusBottomLeft, y: height - tmpBorderRadiusBottomLeft),
                radius: tmpBorderRadiusBottomLeft,
                startAngle: CGFloat(Double.pi / 2),
                endAngle: CGFloat(Double.pi),
                clockwise: true
            )
        
            // top-left corner

            path.addLine(to: CGPoint(x: 0, y: tmpBorderRadiusTopLeft))
        
            path.addArc(
                withCenter: CGPoint(x: tmpBorderRadiusTopLeft, y: tmpBorderRadiusTopLeft),
                radius: tmpBorderRadiusTopLeft,
                startAngle: CGFloat(Double.pi),
                endAngle: CGFloat(3 * Double.pi / 2),
                clockwise: true
            )
            
            path.close()
            
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.path = path.cgPath
            
            self.view.layer.mask = shapeLayer
        }
    }
    
    private func convertBorderRadius(size: StyleSize?, width: CGFloat, height: CGFloat) -> CGFloat {
        let minSize = Float(min(width, height))
        
        let maxRadius = minSize / 2
        
        var value: Float = 0
        
        switch size {
        case .float(let float):
            value = float
            
            break
        
        case .string(let string):
            value = minSize * AttributeHelper.convertPercentStringToFloat(string)!
            
            break
            
        default:
            break
        }
        
        return CGFloat(min(value, maxRadius))
    }

    open func patchBorderWidth(borderWidth: Float?) -> Void {
    }

    open func patchBorderColor(borderColor: StyleColor?) -> Void {
    }

    open func patchBorderTopWidth(borderTopWidth: Float?) -> Void {
    }

    open func patchBorderTopColor(borderTopColor: StyleColor?) -> Void {
    }

    open func patchBorderLeftWidth(borderLeftWidth: Float?) -> Void {
    }

    open func patchBorderLeftColor(borderLeftColor: StyleColor?) -> Void {
    }

    open func patchBorderBottomWidth(borderBottomWidth: Float?) -> Void {
    }

    open func patchBorderBottomColor(borderBottomColor: StyleColor?) -> Void {
    }

    open func patchBorderRightWidth(borderRightWidth: Float?) -> Void {
    }

    open func patchBorderRightColor(borderRightColor: StyleColor?) -> Void {
    }
    
    open func patchTransform(transform: StyleTransform?) -> Void {
        let layoutParams = view.layoutParams
        
        layoutParams.onLayoutClosures["transform"] = {
            var translateX: CGFloat = 0;
            var translateY: CGFloat = 0;

            var scaleX: CGFloat = 1;
            var scaleY: CGFloat = 1;
            
            if let transform = transform {
                if transform.translateX != nil {
                    translateX = self.getTranslate(self.view.frame.size.width, transform.translateX!);
                }
                
                if transform.translateY != nil {
                    translateY = self.getTranslate(self.view.frame.size.height, transform.translateY!);
                }
                
                if transform.scale != nil {
                    let scale = self.getScale(transform.scale!)
                    
                    scaleX = scale
                    scaleY = scale
                }
                
                if transform.scaleX != nil {
                    scaleX = self.getScale(transform.scaleX!);
                }
                
                if transform.scaleY != nil {
                    scaleY = self.getScale(transform.scaleY!);
                }
            }
            
            self.view.frame.origin.x += translateX
            self.view.frame.origin.y += translateY
            
//            self.view.transform = CGAffineTransform.identity
//                .scaledBy(x: scaleX, y: scaleY)
        }
    }
    
    func getTranslate(_ size: CGFloat, _ translateValue: StyleSize) -> CGFloat {
        switch translateValue {
        case .float(let float):
            return CGFloat(float)
            
            break
        
        case .string(let string):
            let percent = AttributeHelper.convertPercentStringToFloat(string)!
            
            return size * CGFloat(percent)
            
            break
        }
        
        return 0
    }
    
    func getScale(_ scaleValue: StyleSize) -> CGFloat {
        switch scaleValue {
        case .float(let float):
            return CGFloat(float)
            
            break
        
        case .string(let string):
            return CGFloat(AttributeHelper.convertPercentStringToFloat(string)!)
            
            break
        }
        
        return 0
    }
    
    public func applyStyle(styleEntries: [StyleEntry]) -> Void {
        let style = createStyle(styleEntries: self.styleEntries)
        
        if additionalStyleEntry == nil {
            additionalStyleEntry = StyleEntry(style: Style(), keys: [])
        }
        
        for styleEntry in styleEntries {
            StyleSheetHelper.fillStyleEntry(styleEntry: additionalStyleEntry!, tmpStyleEntry: styleEntry)
        }
        
        let tmpStyle = createStyle(styleEntries: self.styleEntries)
        
        let tmpStyler = Styler(style: tmpStyle)
        let styler = Styler(style: style)
        
        patchStyler(styler: tmpStyler, prevStyler: styler)
    }
    
    public func removeStyle(toRemoveKeys: [[String]?]) -> Void {
        let style = createStyle(styleEntries: self.styleEntries)

        for tmpKeys in toRemoveKeys {
            if tmpKeys == nil {
                additionalStyleEntry = nil
                
                continue
            }
            
            if additionalStyleEntry == nil {
                continue
            }
            
            StyleSheetHelper.removeStyleEntryKeys(styleEntry: additionalStyleEntry!, keys: tmpKeys!)
        }
        
        let tmpStyle = createStyle(styleEntries: self.styleEntries)
        
        let tmpStyler = Styler(style: tmpStyle)
        let styler = Styler(style: style)
        
        patchStyler(styler: tmpStyler, prevStyler: styler)
    }
    
    private func createStyle(styleEntries: [StyleEntry]) -> Style {
        var tmpStyleEntries: [StyleEntry] = []
        
        tmpStyleEntries.append(contentsOf: styleEntries)
        
        if additionalStyleEntry != nil {
            tmpStyleEntries.append(additionalStyleEntry!)
        }
        
        return StyleSheetHelper.createStyle(styleEntries: tmpStyleEntries)
    }
    
    public func remove() {
        removeView()
    }
    
    open func createView() -> UIView {
        preconditionFailure("This method must be overridden.")
    }
    
    open func patchView() {}
    open func removeView() {}
    
    func resignFirstResponder(_ view: UIView) {
        if view.isFirstResponder {
            view.resignFirstResponder()
        }
        
        for subview in view.subviews {
            resignFirstResponder(subview)
        }
    }
    
    @objc func onTapListener(_ gestureRecognizer: UITapGestureRecognizer) {
        sendHandler(name: "onTap")
    }
    
    @objc func onLongTapListener(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            sendHandler(name: "onLongTap")
        }
    }
    
    struct Handler: Encodable {
        let name: String
        let edgeId: Int
        let data: AnyEncodable??

        init(name: String, edgeId: Int, data: Encodable?) {
            self.name = name
            self.edgeId = edgeId
            
            if let data = data {
                self.data = AnyEncodable(data)
            } else {
                self.data = .some(nil)
            }
        }
    }
}
