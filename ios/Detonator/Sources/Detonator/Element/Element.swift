import UIKit

class Attributes: Decodable {
    let style: Style?
    let onTap: Bool?
    let onDoubleTap: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case style
        case onTap
        case onDoubleTap
    }
}

class Element: NSObject {
    let detonator: Detonator
    
    var edge: Edge!
    var currentEdge: Edge?
    
    var view: UIView!
    
    var attributes: Attributes!
    var currentAttributes: Attributes?
    
    var styler: Styler!
    var currentStyler: Styler!
    
    var forcePatch: Bool = true
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    required init(_ detonator: Detonator) {
        self.detonator = detonator
        
        super.init()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapListener(_:)))
    }
    
    func decodeAttributes<T: Attributes>(edge: Edge) -> T? {
        if let json = edge.attributes!.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                
                let attributes = try decoder.decode(T.self, from: json)
                
                return attributes;
            } catch {}
        }
        
        return nil
    }
    
    func decodeAttributes(edge: Edge) -> Attributes? {
        preconditionFailure("This method must be overridden.")
    }
    
    public func create() {
        let view = createView()
                
        view.addGestureRecognizer(tapGestureRecognizer)
        
        self.view = view
    }
    
    public func patch() {
        attributes = decodeAttributes(edge: edge)
        
        currentAttributes = currentEdge != nil ? decodeAttributes(edge: currentEdge!) : nil
        
        forcePatch = currentAttributes == nil
        
        styler = Styler(style: attributes.style)
        currentStyler = Styler(style: currentAttributes?.style)
                
        let flex = styler.getFlex()
        let flexDirection = styler.getFlexDirection()
        let justifyContent = styler.getJustifyContent()
        let alignItems = styler.getAlignItems()
        let alignSelf = styler.getAlignSelf()
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

        let currentFlex = currentStyler.getFlex()
        let currentFlexDirection = currentStyler.getFlexDirection()
        let currentJustifyContent = currentStyler.getJustifyContent()
        let currentAlignItems = currentStyler.getAlignItems()
        let currentAlignSelf = currentStyler.getAlignSelf()
        let currentBackgroundColor = currentStyler.getBackgroundColor()
        let currentWidth = currentStyler.getWidth()
        let currentHeight = currentStyler.getHeight()
        let currentMinWidth = currentStyler.getMinWidth()
        let currentMinHeight = currentStyler.getMinHeight()
        let currentMaxWidth = currentStyler.getMaxWidth()
        let currentMaxHeight = currentStyler.getMaxHeight()
        let currentPadding = currentStyler.getPadding()
        let currentPaddingHorizontal = currentStyler.getPaddingHorizontal()
        let currentPaddingVertical = currentStyler.getPaddingVertical()
        let currentPaddingTop = currentStyler.getPaddingTop()
        let currentPaddingLeft = currentStyler.getPaddingLeft()
        let currentPaddingBottom = currentStyler.getPaddingBottom()
        let currentPaddingRight = currentStyler.getPaddingRight()
        let currentMargin = currentStyler.getMargin()
        let currentMarginHorizontal = currentStyler.getMarginHorizontal()
        let currentMarginVertical = currentStyler.getMarginVertical()
        let currentMarginTop = currentStyler.getMarginTop()
        let currentMarginLeft = currentStyler.getMarginLeft()
        let currentMarginBottom = currentStyler.getMarginBottom()
        let currentMarginRight = currentStyler.getMarginRight()
        let currentFontSize = currentStyler.getFontSize()
        let currentLineHeight = currentStyler.getLineHeight()
        let currentFontWeight = currentStyler.getFontWeight()
        let currentColor = currentStyler.getColor()
        let currentTextAlign = currentStyler.getTextAlign()
        let currentTextDecoration = currentStyler.getTextDecoration()
        let currentTextTransform = currentStyler.getTextTransform()
        let currentTextOverflow = currentStyler.getTextOverflow()
        let currentOverflowWrap = currentStyler.getOverflowWrap()
        let currentWordBreak = currentStyler.getWordBreak()
        let currentPosition = currentStyler.getPosition()
        let currentTop = currentStyler.getTop()
        let currentLeft = currentStyler.getLeft()
        let currentBottom = currentStyler.getBottom()
        let currentRight = currentStyler.getRight()
        let currentZIndex = currentStyler.getZIndex()
        let currentDisplay = currentStyler.getDisplay()
        let currentPointerEvents = currentStyler.getPointerEvents()
        let currentObjectFit = currentStyler.getObjectFit()
        let currentOverflow = currentStyler.getOverflow()
        let currentOpacity = currentStyler.getOpacity()
        let currentAspectRatio = currentStyler.getAspectRatio()
        let currentBorderRadius = currentStyler.getBorderRadius()
        let currentBorderRadiusTopLeft = currentStyler.getBorderRadiusTopLeft()
        let currentBorderRadiusTopRight = currentStyler.getBorderRadiusTopRight()
        let currentBorderRadiusBottomLeft = currentStyler.getBorderRadiusBottomLeft()
        let currentBorderRadiusBottomRight = currentStyler.getBorderRadiusBottomRight()
        let currentBorderWidth = currentStyler.getBorderWidth()
        let currentBorderColor = currentStyler.getBorderColor()
        let currentBorderTopWidth = currentStyler.getBorderTopWidth()
        let currentBorderTopColor = currentStyler.getBorderTopColor()
        let currentBorderLeftWidth = currentStyler.getBorderLeftWidth()
        let currentBorderLeftColor = currentStyler.getBorderLeftColor()
        let currentBorderBottomWidth = currentStyler.getBorderBottomWidth()
        let currentBorderBottomColor = currentStyler.getBorderBottomColor()
        let currentBorderRightWidth = currentStyler.getBorderRightWidth()
        let currentBorderRightColor = currentStyler.getBorderRightColor()

        let patchFlexBool = forcePatch || flex != currentFlex
        let patchFlexDirectionBool = forcePatch || flexDirection != currentFlexDirection
        let patchJustifyContentBool = forcePatch || justifyContent != currentJustifyContent
        let patchAlignItemsBool = forcePatch || alignItems != currentAlignItems
        let patchAlignSelfBool = forcePatch || alignSelf != currentAlignSelf
        let patchBackgroundColorBool = forcePatch || !CompareHelper.compareStyleColors(backgroundColor, currentBackgroundColor)
        let patchWidthBool = forcePatch || !CompareHelper.compareStyleSizes(width, currentWidth)
        let patchHeightBool = forcePatch || !CompareHelper.compareStyleSizes(height, currentHeight)
        let patchMinWidthBool = forcePatch || !CompareHelper.compareStyleSizes(minWidth, currentMinWidth)
        let patchMinHeightBool = forcePatch || !CompareHelper.compareStyleSizes(minHeight, currentMinHeight)
        let patchMaxWidthBool = forcePatch || !CompareHelper.compareStyleSizes(maxWidth, currentMaxWidth)
        let patchMaxHeightBool = forcePatch || !CompareHelper.compareStyleSizes(maxHeight, currentMaxHeight)
        let patchPaddingBool = forcePatch || padding != currentPadding
        let patchPaddingHorizontalBool = forcePatch || paddingHorizontal != currentPaddingHorizontal
        let patchPaddingVerticalBool = forcePatch || paddingVertical != currentPaddingVertical
        let patchPaddingTopBool = forcePatch || paddingTop != currentPaddingTop
        let patchPaddingLeftBool = forcePatch || paddingLeft != currentPaddingLeft
        let patchPaddingBottomBool = forcePatch || paddingBottom != currentPaddingBottom
        let patchPaddingRightBool = forcePatch || paddingRight != currentPaddingRight
        let patchMarginBool = forcePatch || margin != currentMargin
        let patchMarginHorizontalBool = forcePatch || marginHorizontal != currentMarginHorizontal
        let patchMarginVerticalBool = forcePatch || marginVertical != currentMarginVertical
        let patchMarginTopBool = forcePatch || marginTop != currentMarginTop
        let patchMarginLeftBool = forcePatch || marginLeft != currentMarginLeft
        let patchMarginBottomBool = forcePatch || marginBottom != currentMarginBottom
        let patchMarginRightBool = forcePatch || marginRight != currentMarginRight
        let patchFontSizeBool = forcePatch || fontSize != currentFontSize
        let patchLineHeightBool = forcePatch || lineHeight != currentLineHeight
        let patchFontWeightBool = forcePatch || fontWeight != currentFontWeight
        let patchColorBool = forcePatch || !CompareHelper.compareStyleColors(color, currentColor)
        let patchTextAlignBool = forcePatch || textAlign != currentTextAlign
        let patchTextDecorationBool = forcePatch || textDecoration != currentTextDecoration
        let patchTextTransformBool = forcePatch || textTransform != currentTextTransform
        let patchTextOverflowBool = forcePatch || textOverflow != currentTextOverflow
        let patchOverflowWrapBool = forcePatch || overflowWrap != currentOverflowWrap
        let patchWordBreakBool = forcePatch || wordBreak != currentWordBreak
        let patchPositionBool = forcePatch || position != currentPosition
        let patchTopBool = forcePatch || top != currentTop
        let patchLeftBool = forcePatch || left != currentLeft
        let patchBottomBool = forcePatch || bottom != currentBottom
        let patchRightBool = forcePatch || right != currentRight
        let patchZIndexBool = forcePatch || zIndex != currentZIndex
        let patchDisplayBool = forcePatch || display != currentDisplay
        let patchPointerEventsBool = forcePatch || pointerEvents != currentPointerEvents
        let patchObjectFitBool = forcePatch || objectFit != currentObjectFit
        let patchOverflowBool = forcePatch || overflow != currentOverflow
        let patchOpacityBool = forcePatch || opacity != currentOpacity
        let patchAspectRatioBool = forcePatch || aspectRatio != currentAspectRatio
        let patchBorderRadiusBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadius, currentBorderRadius)
        let patchBorderRadiusTopLeftBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadiusTopLeft, currentBorderRadiusTopLeft)
        let patchBorderRadiusTopRightBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadiusTopRight, currentBorderRadiusTopRight)
        let patchBorderRadiusBottomLeftBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadiusBottomLeft, currentBorderRadiusBottomLeft)
        let patchBorderRadiusBottomRightBool = forcePatch || !CompareHelper.compareStyleSizes(borderRadiusBottomRight, currentBorderRadiusBottomRight)
        let patchBorderWidthBool = forcePatch || borderWidth != currentBorderWidth
        let patchBorderColorBool = forcePatch || !CompareHelper.compareStyleColors(borderColor, currentBorderColor)
        let patchBorderTopWidthBool = forcePatch || borderTopWidth != currentBorderTopWidth
        let patchBorderTopColorBool = forcePatch || !CompareHelper.compareStyleColors(borderTopColor, currentBorderTopColor)
        let patchBorderLeftWidthBool = forcePatch || borderLeftWidth != currentBorderLeftWidth
        let patchBorderLeftColorBool = forcePatch || !CompareHelper.compareStyleColors(borderLeftColor, currentBorderLeftColor)
        let patchBorderBottomWidthBool = forcePatch || borderBottomWidth != currentBorderBottomWidth
        let patchBorderBottomColorBool = forcePatch || !CompareHelper.compareStyleColors(borderBottomColor, currentBorderBottomColor)
        let patchBorderRightWidthBool = forcePatch || borderRightWidth != currentBorderRightWidth
        let patchBorderRightColorBool = forcePatch || !CompareHelper.compareStyleColors(borderRightColor, currentBorderRightColor)

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
        
        patchView()
    }
    
    public func patchFlex(flex: Int?) {
        let layoutParams = view.layoutParams
        
        layoutParams.flex = flex
    }

    public func patchFlexDirection(flexDirection: String?) {
    }

    public func patchJustifyContent(justifyContent: String?) {
    }

    public func patchAlignItems(alignItems: String?) {
    }

    public func patchAlignSelf(alignSelf: String?) {
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

    public func patchBackgroundColor(backgroundColor: StyleColor?) {
        let tmpBackgroundColor = backgroundColor != nil ? ColorHelper.parseColor(color: backgroundColor!) : nil
                    
        view.backgroundColor = tmpBackgroundColor ?? UIColor.clear
    }

    public func patchWidth(width: StyleSize?) {
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

    public func patchHeight(height: StyleSize?) {
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

    public func patchMinWidth(minWidth: StyleSize?) {
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

    public func patchMinHeight(minHeight: StyleSize?) {
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

    public func patchMaxWidth(maxWidth: StyleSize?) {
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

    public func patchMaxHeight(maxHeight: StyleSize?) {
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

    public func patchPadding(
        padding: Float?,
        paddingHorizontal: Float?,
        paddingVertical: Float?,
        paddingTop: Float?,
        paddingLeft: Float?,
        paddingBottom: Float?,
        paddingRight: Float?
    ) {
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

    public func patchMargin(
        margin: Float?,
        marginHorizontal: Float?,
        marginVertical: Float?,
        marginTop: Float?,
        marginLeft: Float?,
        marginBottom: Float?,
        marginRight: Float?
    ) {
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

    public func patchFontSize(fontSize: Float?) {
    }

    public func patchLineHeight(lineHeight: Float?) {
    }

    public func patchFontWeight(fontWeight: String?) {
    }

    public func patchColor(color: StyleColor?) {
    }

    public func patchTextAlign(textAlign: String?) {
    }

    public func patchTextDecoration(textDecoration: String?) {
    }

    public func patchTextTransform(textTransform: String?) {
    }

    public func patchTextOverflow(textOverflow: String?) {
    }

    public func patchOverflowWrap(overflowWrap: String?) {
    }

    public func patchWordBreak(wordBreak: String?) {
    }

    public func patchPosition(position: String?) {
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

    public func patchTop(top: Float?) {
        let layoutParams = view.layoutParams
        
        layoutParams.positionTop = top
    }

    public func patchLeft(left: Float?) {
        let layoutParams = view.layoutParams
        
        layoutParams.positionLeft = left
    }

    public func patchBottom(bottom: Float?) {
        let layoutParams = view.layoutParams
        
        layoutParams.positionBottom = bottom
    }

    public func patchRight(right: Float?) {
        let layoutParams = view.layoutParams
        
        layoutParams.positionRight = right
    }

    public func patchZIndex(zIndex: Int?) {
        view.layer.zPosition = zIndex != nil ? CGFloat(zIndex!) : 0
    }

    public func patchDisplay(display: String?) {
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

    public func patchPointerEvents(pointerEvents: String?) {
    }

    public func patchObjectFit(objectFit: String?) {
    }

    public func patchOverflow(overflow: String?) {
    }

    public func patchOpacity(opacity: Float?) {
        view.alpha = opacity != nil ? CGFloat(opacity!) : 1.0
    }

    public func patchAspectRatio(aspectRatio: Float?) {
        let layoutParams = view.layoutParams
        
        layoutParams.aspectRatio = aspectRatio
    }

    public func patchBorderRadius(
        borderRadius: StyleSize?,
        borderRadiusTopLeft: StyleSize?,
        borderRadiusTopRight: StyleSize?,
        borderRadiusBottomLeft: StyleSize?,
        borderRadiusBottomRight: StyleSize?
    ) {
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

    public func patchBorderWidth(borderWidth: Float?) {
    }

    public func patchBorderColor(borderColor: StyleColor?) {
    }

    public func patchBorderTopWidth(borderTopWidth: Float?) {
    }

    public func patchBorderTopColor(borderTopColor: StyleColor?) {
    }

    public func patchBorderLeftWidth(borderLeftWidth: Float?) {
    }

    public func patchBorderLeftColor(borderLeftColor: StyleColor?) {
    }

    public func patchBorderBottomWidth(borderBottomWidth: Float?) {
    }

    public func patchBorderBottomColor(borderBottomColor: StyleColor?) {
    }

    public func patchBorderRightWidth(borderRightWidth: Float?) {
    }

    public func patchBorderRightColor(borderRightColor: StyleColor?) {
    }
    
    public func applyStyle(style: Style, keys: [String]) {
        let styler = Styler(style: style)
        
        let flex = styler.getFlex()
        let flexDirection = styler.getFlexDirection()
        let justifyContent = styler.getJustifyContent()
        let alignItems = styler.getAlignItems()
        let alignSelf = styler.getAlignSelf()
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
    
        let patchFlexBool = keys.contains("flex")
        let patchFlexDirectionBool = keys.contains("flexDirection")
        let patchJustifyContentBool = keys.contains("justifyContent")
        let patchAlignItemsBool = keys.contains("alignItems")
        let patchAlignSelfBool = keys.contains("alignSelf")
        let patchBackgroundColorBool = keys.contains("backgroundColor")
        let patchWidthBool = keys.contains("width")
        let patchHeightBool = keys.contains("height")
        let patchMinWidthBool = keys.contains("minWidth")
        let patchMinHeightBool = keys.contains("minHeight")
        let patchMaxWidthBool = keys.contains("maxWidth")
        let patchMaxHeightBool = keys.contains("maxHeight")
        let patchPaddingBool = keys.contains("padding")
        let patchPaddingHorizontalBool = keys.contains("paddingHorizontal")
        let patchPaddingVerticalBool = keys.contains("paddingVertical")
        let patchPaddingTopBool = keys.contains("paddingTop")
        let patchPaddingLeftBool = keys.contains("paddingLeft")
        let patchPaddingBottomBool = keys.contains("paddingBottom")
        let patchPaddingRightBool = keys.contains("paddingRight")
        let patchMarginBool = keys.contains("margin")
        let patchMarginHorizontalBool = keys.contains("marginHorizontal")
        let patchMarginVerticalBool = keys.contains("marginVertical")
        let patchMarginTopBool = keys.contains("marginTop")
        let patchMarginLeftBool = keys.contains("marginLeft")
        let patchMarginBottomBool = keys.contains("marginBottom")
        let patchMarginRightBool = keys.contains("marginRight")
        let patchFontSizeBool = keys.contains("fontSize")
        let patchLineHeightBool = keys.contains("lineHeight")
        let patchFontWeightBool = keys.contains("fontWeight")
        let patchColorBool = keys.contains("color")
        let patchTextAlignBool = keys.contains("textAlign")
        let patchTextDecorationBool = keys.contains("textDecoration")
        let patchTextTransformBool = keys.contains("textTransform")
        let patchTextOverflowBool = keys.contains("textOverflow")
        let patchOverflowWrapBool = keys.contains("overflowWrap")
        let patchWordBreakBool = keys.contains("wordBreak")
        let patchPositionBool = keys.contains("position")
        let patchTopBool = keys.contains("top")
        let patchLeftBool = keys.contains("left")
        let patchBottomBool = keys.contains("bottom")
        let patchRightBool = keys.contains("right")
        let patchZIndexBool = keys.contains("zIndex")
        let patchDisplayBool = keys.contains("display")
        let patchPointerEventsBool = keys.contains("pointerEvents")
        let patchObjectFitBool = keys.contains("objectFit")
        let patchOverflowBool = keys.contains("overflow")
        let patchOpacityBool = keys.contains("opacity")
        let patchAspectRatioBool = keys.contains("aspectRatio")
        let patchBorderRadiusBool = keys.contains("borderRadius")
        let patchBorderRadiusTopLeftBool = keys.contains("borderRadiusTopLeft")
        let patchBorderRadiusTopRightBool = keys.contains("borderRadiusTopRight")
        let patchBorderRadiusBottomLeftBool = keys.contains("borderRadiusBottomLeft")
        let patchBorderRadiusBottomRightBool = keys.contains("borderRadiusBottomRight")
        let patchBorderWidthBool = keys.contains("borderWidth")
        let patchBorderColorBool = keys.contains("borderColor")
        let patchBorderTopWidthBool = keys.contains("borderTopWidth")
        let patchBorderTopColorBool = keys.contains("borderTopColor")
        let patchBorderLeftWidthBool = keys.contains("borderLeftWidth")
        let patchBorderLeftColorBool = keys.contains("borderLeftColor")
        let patchBorderBottomWidthBool = keys.contains("borderBottomWidth")
        let patchBorderBottomColorBool = keys.contains("borderBottomColor")
        let patchBorderRightWidthBool = keys.contains("borderRightWidth")
        let patchBorderRightColorBool = keys.contains("borderRightColor")

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
                padding: patchPaddingBool ? padding : self.styler.getPadding(),
                paddingHorizontal: patchPaddingHorizontalBool ? paddingHorizontal : self.styler.getPaddingHorizontal(),
                paddingVertical: patchPaddingVerticalBool ? paddingVertical : self.styler.getPaddingVertical(),
                paddingTop: patchPaddingTopBool ? paddingTop : self.styler.getPaddingTop(),
                paddingLeft: patchPaddingLeftBool ? paddingLeft : self.styler.getPaddingLeft(),
                paddingBottom: patchPaddingBottomBool ? paddingBottom : self.styler.getPaddingBottom(),
                paddingRight: patchPaddingRightBool ? paddingRight : self.styler.getPaddingRight()
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
                margin: patchMarginBool ? margin : self.styler.getMargin(),
                marginHorizontal: patchMarginHorizontalBool ? marginHorizontal : self.styler.getMarginHorizontal(),
                marginVertical: patchMarginVerticalBool ? marginVertical : self.styler.getMarginVertical(),
                marginTop: patchMarginTopBool ? marginTop : self.styler.getMarginTop(),
                marginLeft: patchMarginLeftBool ? marginLeft : self.styler.getMarginLeft(),
                marginBottom: patchMarginBottomBool ? marginBottom : self.styler.getMarginBottom(),
                marginRight: patchMarginRightBool ? marginRight : self.styler.getMarginRight()
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
                borderRadius: patchBorderRadiusBool ? borderRadius : self.styler.getBorderRadius(),
                borderRadiusTopLeft: patchBorderRadiusTopLeftBool ? borderRadiusTopLeft : self.styler.getBorderRadiusTopLeft(),
                borderRadiusTopRight: patchBorderRadiusTopRightBool ? borderRadiusTopRight : self.styler.getBorderRadiusTopRight(),
                borderRadiusBottomLeft: patchBorderRadiusBottomLeftBool ? borderRadiusBottomLeft: self.styler.getBorderRadiusBottomLeft(),
                borderRadiusBottomRight: patchBorderRadiusBottomRightBool ? borderRadiusBottomRight : self.styler.getBorderRadiusBottomRight()
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
    }
    
    func createView() -> UIView {
        preconditionFailure("This method must be overridden.")
    }
    
    func patchView() {
        preconditionFailure("This method must be overridden.")
    }
    
    func resignFirstResponder(_ view: UIView) {
        if view.isFirstResponder {
            view.resignFirstResponder()
        }
        
        for subview in view.subviews {
            resignFirstResponder(subview)
        }
    }
    
    @objc func onTapListener(_ sender: UITapGestureRecognizer) {
        detonator.handlerEmitter.emit(name: "onTap", edgeId: edge.id, data: nil)
    }
}
