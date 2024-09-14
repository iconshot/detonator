class Styler {
    let style: Style?
    
    init(style: Style?) {
        self.style = style
    }
    
    public func getFlex() -> Int? {
        return style?.flex
    }
    
    public func getFlexDirection() -> String? {
        return style?.flexDirection
    }
    
    public func getJustifyContent() -> String? {
        return style?.justifyContent
    }
    
    public func getAlignItems() -> String? {
        return style?.alignItems
    }
    
    public func getAlignSelf() -> String? {
        return style?.alignSelf
    }
    
    public func getBackgroundColor() -> StyleColor? {
        return style?.backgroundColor
    }
    
    public func getWidth() -> StyleSize? {
        return style?.width
    }
    
    public func getHeight() -> StyleSize? {
        return style?.height
    }
    
    public func getMinWidth() -> StyleSize? {
        return style?.minWidth
    }
    
    public func getMinHeight() -> StyleSize? {
        return style?.minHeight
    }
    
    public func getMaxWidth() -> StyleSize? {
        return style?.maxWidth
    }
    
    public func getMaxHeight() -> StyleSize? {
        return style?.maxHeight
    }
    
    public func getPadding() -> Float? {
        return style?.padding
    }
    
    public func getPaddingTop() -> Float? {
        return style?.paddingTop
    }
    
    public func getPaddingLeft() -> Float? {
        return style?.paddingLeft
    }
    
    public func getPaddingBottom() -> Float? {
        return style?.paddingBottom
    }
    
    public func getPaddingRight() -> Float? {
        return style?.paddingRight
    }
    
    public func getMargin() -> Float? {
        return style?.margin
    }
    
    public func getMarginTop() -> Float? {
        return style?.marginTop
    }
    
    public func getMarginLeft() -> Float? {
        return style?.marginLeft
    }
    
    public func getMarginBottom() -> Float? {
        return style?.marginBottom
    }
    
    public func getMarginRight() -> Float? {
        return style?.marginRight
    }
    
    public func getFontSize() -> Float? {
        return style?.fontSize
    }
    
    public func getLineHeight() -> Float? {
        return style?.lineHeight
    }
    
    public func getFontWeight() -> String? {
        return style?.fontWeight
    }
    
    public func getColor() -> StyleColor? {
        return style?.color
    }
    
    public func getTextAlign() -> String? {
        return style?.textAlign
    }
    
    public func getTextDecoration() -> String? {
        return style?.textDecoration
    }
    
    public func getTextTransform() -> String? {
        return style?.textTransform
    }
    
    public func getTextOverflow() -> String? {
        return style?.textOverflow
    }
    
    public func getOverflowWrap() -> String? {
        return style?.overflowWrap
    }
    
    public func getWordBreak() -> String? {
        return style?.wordBreak
    }
    
    public func getPosition() -> String? {
        return style?.position
    }
    
    public func getTop() -> Float? {
        return style?.top
    }
    
    public func getLeft() -> Float? {
        return style?.left
    }
    
    public func getBottom() -> Float? {
        return style?.bottom
    }
    
    public func getRight() -> Float? {
        return style?.right
    }
    
    public func getZIndex() -> Int? {
        return style?.zIndex
    }
    
    public func getDisplay() -> String? {
        return style?.display
    }
    
    public func getPointerEvents() -> String? {
        return style?.pointerEvents
    }
    
    public func getObjectFit() -> String? {
        return style?.objectFit
    }
    
    public func getOverflow() -> String? {
        return style?.overflow
    }
    
    public func getOpacity() -> Float? {
        return style?.opacity
    }
    
    public func getAspectRatio() -> Float? {
        return style?.aspectRatio
    }
    
    public func getBorderRadius() -> StyleSize? {
        return style?.borderRadius
    }
    
    public func getBorderRadiusTopLeft() -> StyleSize? {
        return style?.borderRadiusTopLeft
    }
    
    public func getBorderRadiusTopRight() -> StyleSize? {
        return style?.borderRadiusTopRight
    }
    
    public func getBorderRadiusBottomLeft() -> StyleSize? {
        return style?.borderRadiusBottomLeft
    }
    
    public func getBorderRadiusBottomRight() -> StyleSize? {
        return style?.borderRadiusBottomRight
    }
    
    public func getBorderWidth() -> Float? {
        return style?.borderWidth
    }
    
    public func getBorderColor() -> StyleColor? {
        return style?.borderColor
    }
    
    public func getBorderTopWidth() -> Float? {
        return style?.borderTopWidth
    }
    
    public func getBorderTopColor() -> StyleColor? {
        return style?.borderTopColor
    }
    
    public func getBorderLeftWidth() -> Float? {
        return style?.borderLeftWidth
    }
    
    public func getBorderLeftColor() -> StyleColor? {
        return style?.borderLeftColor
    }
    
    public func getBorderBottomWidth() -> Float? {
        return style?.borderBottomWidth
    }
    
    public func getBorderBottomColor() -> StyleColor? {
        return style?.borderBottomColor
    }
    
    public func getBorderRightWidth() -> Float? {
        return style?.borderRightWidth
    }
    
    public func getBorderRightColor() -> StyleColor? {
        return style?.borderRightColor
    }
}
