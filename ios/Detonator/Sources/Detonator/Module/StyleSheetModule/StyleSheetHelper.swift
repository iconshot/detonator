class StyleSheetHelper {
    public static func fillStyle(style: inout Style, styleEntry: StyleEntry) -> Void {
        let includeFlexBool = styleEntry.keys.contains("flex")
        let includeFlexDirectionBool = styleEntry.keys.contains("flexDirection")
        let includeJustifyContentBool = styleEntry.keys.contains("justifyContent")
        let includeAlignItemsBool = styleEntry.keys.contains("alignItems")
        let includeAlignSelfBool = styleEntry.keys.contains("alignSelf")
        let includeGapBool = styleEntry.keys.contains("gap")
        let includeBackgroundColorBool = styleEntry.keys.contains("backgroundColor")
        let includeWidthBool = styleEntry.keys.contains("width")
        let includeHeightBool = styleEntry.keys.contains("height")
        let includeMinWidthBool = styleEntry.keys.contains("minWidth")
        let includeMinHeightBool = styleEntry.keys.contains("minHeight")
        let includeMaxWidthBool = styleEntry.keys.contains("maxWidth")
        let includeMaxHeightBool = styleEntry.keys.contains("maxHeight")
        let includePaddingBool = styleEntry.keys.contains("padding")
        let includePaddingHorizontalBool = styleEntry.keys.contains("paddingHorizontal")
        let includePaddingVerticalBool = styleEntry.keys.contains("paddingVertical")
        let includePaddingTopBool = styleEntry.keys.contains("paddingTop")
        let includePaddingLeftBool = styleEntry.keys.contains("paddingLeft")
        let includePaddingBottomBool = styleEntry.keys.contains("paddingBottom")
        let includePaddingRightBool = styleEntry.keys.contains("paddingRight")
        let includeMarginBool = styleEntry.keys.contains("margin")
        let includeMarginHorizontalBool = styleEntry.keys.contains("marginHorizontal")
        let includeMarginVerticalBool = styleEntry.keys.contains("marginVertical")
        let includeMarginTopBool = styleEntry.keys.contains("marginTop")
        let includeMarginLeftBool = styleEntry.keys.contains("marginLeft")
        let includeMarginBottomBool = styleEntry.keys.contains("marginBottom")
        let includeMarginRightBool = styleEntry.keys.contains("marginRight")
        let includeFontSizeBool = styleEntry.keys.contains("fontSize")
        let includeLineHeightBool = styleEntry.keys.contains("lineHeight")
        let includeFontWeightBool = styleEntry.keys.contains("fontWeight")
        let includeColorBool = styleEntry.keys.contains("color")
        let includeTextAlignBool = styleEntry.keys.contains("textAlign")
        let includeTextDecorationBool = styleEntry.keys.contains("textDecoration")
        let includeTextTransformBool = styleEntry.keys.contains("textTransform")
        let includeTextOverflowBool = styleEntry.keys.contains("textOverflow")
        let includeOverflowWrapBool = styleEntry.keys.contains("overflowWrap")
        let includeWordBreakBool = styleEntry.keys.contains("wordBreak")
        let includePositionBool = styleEntry.keys.contains("position")
        let includeTopBool = styleEntry.keys.contains("top")
        let includeLeftBool = styleEntry.keys.contains("left")
        let includeBottomBool = styleEntry.keys.contains("bottom")
        let includeRightBool = styleEntry.keys.contains("right")
        let includeZIndexBool = styleEntry.keys.contains("zIndex")
        let includeDisplayBool = styleEntry.keys.contains("display")
        let includePointerEventsBool = styleEntry.keys.contains("pointerEvents")
        let includeObjectFitBool = styleEntry.keys.contains("objectFit")
        let includeOverflowBool = styleEntry.keys.contains("overflow")
        let includeOpacityBool = styleEntry.keys.contains("opacity")
        let includeAspectRatioBool = styleEntry.keys.contains("aspectRatio")
        let includeBorderRadiusBool = styleEntry.keys.contains("borderRadius")
        let includeBorderRadiusTopLeftBool = styleEntry.keys.contains("borderRadiusTopLeft")
        let includeBorderRadiusTopRightBool = styleEntry.keys.contains("borderRadiusTopRight")
        let includeBorderRadiusBottomLeftBool = styleEntry.keys.contains("borderRadiusBottomLeft")
        let includeBorderRadiusBottomRightBool = styleEntry.keys.contains("borderRadiusBottomRight")
        let includeBorderWidthBool = styleEntry.keys.contains("borderWidth")
        let includeBorderColorBool = styleEntry.keys.contains("borderColor")
        let includeBorderTopWidthBool = styleEntry.keys.contains("borderTopWidth")
        let includeBorderTopColorBool = styleEntry.keys.contains("borderTopColor")
        let includeBorderLeftWidthBool = styleEntry.keys.contains("borderLeftWidth")
        let includeBorderLeftColorBool = styleEntry.keys.contains("borderLeftColor")
        let includeBorderBottomWidthBool = styleEntry.keys.contains("borderBottomWidth")
        let includeBorderBottomColorBool = styleEntry.keys.contains("borderBottomColor")
        let includeBorderRightWidthBool = styleEntry.keys.contains("borderRightWidth")
        let includeBorderRightColorBool = styleEntry.keys.contains("borderRightColor")
        let includeTransformBool = styleEntry.keys.contains("transform")

        if includeFlexBool {
            style.flex = styleEntry.style.flex
        }

        if includeFlexDirectionBool {
            style.flexDirection = styleEntry.style.flexDirection
        }

        if includeJustifyContentBool {
            style.justifyContent = styleEntry.style.justifyContent
        }

        if includeAlignItemsBool {
            style.alignItems = styleEntry.style.alignItems
        }

        if includeAlignSelfBool {
            style.alignSelf = styleEntry.style.alignSelf
        }
        
        if includeGapBool {
            style.gap = styleEntry.style.gap
        }
        
        if includeBackgroundColorBool {
            style.backgroundColor = styleEntry.style.backgroundColor
        }

        if includeWidthBool {
            style.width = styleEntry.style.width
        }

        if includeHeightBool {
            style.height = styleEntry.style.height
        }

        if includeMinWidthBool {
            style.minWidth = styleEntry.style.minWidth
        }

        if includeMinHeightBool {
            style.minHeight = styleEntry.style.minHeight
        }

        if includeMaxWidthBool {
            style.maxWidth = styleEntry.style.maxWidth
        }

        if includeMaxHeightBool {
            style.maxHeight = styleEntry.style.maxHeight
        }

        if includePaddingBool {
            style.padding = styleEntry.style.padding
        }

        if includePaddingHorizontalBool {
            style.paddingHorizontal = styleEntry.style.paddingHorizontal
        }

        if includePaddingVerticalBool {
            style.paddingVertical = styleEntry.style.paddingVertical
        }

        if includePaddingTopBool {
            style.paddingTop = styleEntry.style.paddingTop
        }

        if includePaddingLeftBool {
            style.paddingLeft = styleEntry.style.paddingLeft
        }

        if includePaddingBottomBool {
            style.paddingBottom = styleEntry.style.paddingBottom
        }

        if includePaddingRightBool {
            style.paddingRight = styleEntry.style.paddingRight
        }

        if includeMarginBool {
            style.margin = styleEntry.style.margin
        }

        if includeMarginHorizontalBool {
            style.marginHorizontal = styleEntry.style.marginHorizontal
        }

        if includeMarginVerticalBool {
            style.marginVertical = styleEntry.style.marginVertical
        }

        if includeMarginTopBool {
            style.marginTop = styleEntry.style.marginTop
        }

        if includeMarginLeftBool {
            style.marginLeft = styleEntry.style.marginLeft
        }

        if includeMarginBottomBool {
            style.marginBottom = styleEntry.style.marginBottom
        }

        if includeMarginRightBool {
            style.marginRight = styleEntry.style.marginRight
        }

        if includeFontSizeBool {
            style.fontSize = styleEntry.style.fontSize
        }

        if includeLineHeightBool {
            style.lineHeight = styleEntry.style.lineHeight
        }

        if includeFontWeightBool {
            style.fontWeight = styleEntry.style.fontWeight
        }

        if includeColorBool {
            style.color = styleEntry.style.color
        }

        if includeTextAlignBool {
            style.textAlign = styleEntry.style.textAlign
        }

        if includeTextDecorationBool {
            style.textDecoration = styleEntry.style.textDecoration
        }

        if includeTextTransformBool {
            style.textTransform = styleEntry.style.textTransform
        }

        if includeTextOverflowBool {
            style.textOverflow = styleEntry.style.textOverflow
        }

        if includeOverflowWrapBool {
            style.overflowWrap = styleEntry.style.overflowWrap
        }

        if includeWordBreakBool {
            style.wordBreak = styleEntry.style.wordBreak
        }

        if includePositionBool {
            style.position = styleEntry.style.position
        }

        if includeTopBool {
            style.top = styleEntry.style.top
        }

        if includeLeftBool {
            style.left = styleEntry.style.left
        }

        if includeBottomBool {
            style.bottom = styleEntry.style.bottom
        }

        if includeRightBool {
            style.right = styleEntry.style.right
        }

        if includeZIndexBool {
            style.zIndex = styleEntry.style.zIndex
        }

        if includeDisplayBool {
            style.display = styleEntry.style.display
        }

        if includePointerEventsBool {
            style.pointerEvents = styleEntry.style.pointerEvents
        }

        if includeObjectFitBool {
            style.objectFit = styleEntry.style.objectFit
        }

        if includeOverflowBool {
            style.overflow = styleEntry.style.overflow
        }

        if includeOpacityBool {
            style.opacity = styleEntry.style.opacity
        }

        if includeAspectRatioBool {
            style.aspectRatio = styleEntry.style.aspectRatio
        }

        if includeBorderRadiusBool {
            style.borderRadius = styleEntry.style.borderRadius
        }

        if includeBorderRadiusTopLeftBool {
            style.borderRadiusTopLeft = styleEntry.style.borderRadiusTopLeft
        }

        if includeBorderRadiusTopRightBool {
            style.borderRadiusTopRight = styleEntry.style.borderRadiusTopRight
        }

        if includeBorderRadiusBottomLeftBool {
            style.borderRadiusBottomLeft = styleEntry.style.borderRadiusBottomLeft
        }

        if includeBorderRadiusBottomRightBool {
            style.borderRadiusBottomRight = styleEntry.style.borderRadiusBottomRight
        }

        if includeBorderWidthBool {
            style.borderWidth = styleEntry.style.borderWidth
        }

        if includeBorderColorBool {
            style.borderColor = styleEntry.style.borderColor
        }

        if includeBorderTopWidthBool {
            style.borderTopWidth = styleEntry.style.borderTopWidth
        }

        if includeBorderTopColorBool {
            style.borderTopColor = styleEntry.style.borderTopColor
        }

        if includeBorderLeftWidthBool {
            style.borderLeftWidth = styleEntry.style.borderLeftWidth
        }

        if includeBorderLeftColorBool {
            style.borderLeftColor = styleEntry.style.borderLeftColor
        }

        if includeBorderBottomWidthBool {
            style.borderBottomWidth = styleEntry.style.borderBottomWidth
        }

        if includeBorderBottomColorBool {
            style.borderBottomColor = styleEntry.style.borderBottomColor
        }

        if includeBorderRightWidthBool {
            style.borderRightWidth = styleEntry.style.borderRightWidth
        }

        if includeBorderRightColorBool {
            style.borderRightColor = styleEntry.style.borderRightColor
        }

        if includeTransformBool {
            style.transform = styleEntry.style.transform
        }
    }
    
    public static func fillStyle(style: inout Style, styleEntries: [StyleEntry]) -> Void {
        for styleEntry in styleEntries {
            fillStyle(style: &style, styleEntry: styleEntry)
        }
    }
    
    public static func createStyle(styleEntries: [StyleEntry]) -> Style {
        var style = Style()
        
        fillStyle(style: &style, styleEntries: styleEntries)
        
        return style
    }
    
    
    public static func fillStyleEntry(styleEntry: StyleEntry, tmpStyleEntry: StyleEntry) -> Void {
        for tmpKey in tmpStyleEntry.keys {
            if styleEntry.keys.contains(tmpKey) {
                continue
            }
            
            styleEntry.keys.append(tmpKey)
        }
        
        let includeFlexBool = tmpStyleEntry.keys.contains("flex")
        let includeFlexDirectionBool = tmpStyleEntry.keys.contains("flexDirection")
        let includeJustifyContentBool = tmpStyleEntry.keys.contains("justifyContent")
        let includeAlignItemsBool = tmpStyleEntry.keys.contains("alignItems")
        let includeAlignSelfBool = tmpStyleEntry.keys.contains("alignSelf")
        let includeGapBool = tmpStyleEntry.keys.contains("gap")
        let includeBackgroundColorBool = tmpStyleEntry.keys.contains("backgroundColor")
        let includeWidthBool = tmpStyleEntry.keys.contains("width")
        let includeHeightBool = tmpStyleEntry.keys.contains("height")
        let includeMinWidthBool = tmpStyleEntry.keys.contains("minWidth")
        let includeMinHeightBool = tmpStyleEntry.keys.contains("minHeight")
        let includeMaxWidthBool = tmpStyleEntry.keys.contains("maxWidth")
        let includeMaxHeightBool = tmpStyleEntry.keys.contains("maxHeight")
        let includePaddingBool = tmpStyleEntry.keys.contains("padding")
        let includePaddingHorizontalBool = tmpStyleEntry.keys.contains("paddingHorizontal")
        let includePaddingVerticalBool = tmpStyleEntry.keys.contains("paddingVertical")
        let includePaddingTopBool = tmpStyleEntry.keys.contains("paddingTop")
        let includePaddingLeftBool = tmpStyleEntry.keys.contains("paddingLeft")
        let includePaddingBottomBool = tmpStyleEntry.keys.contains("paddingBottom")
        let includePaddingRightBool = tmpStyleEntry.keys.contains("paddingRight")
        let includeMarginBool = tmpStyleEntry.keys.contains("margin")
        let includeMarginHorizontalBool = tmpStyleEntry.keys.contains("marginHorizontal")
        let includeMarginVerticalBool = tmpStyleEntry.keys.contains("marginVertical")
        let includeMarginTopBool = tmpStyleEntry.keys.contains("marginTop")
        let includeMarginLeftBool = tmpStyleEntry.keys.contains("marginLeft")
        let includeMarginBottomBool = tmpStyleEntry.keys.contains("marginBottom")
        let includeMarginRightBool = tmpStyleEntry.keys.contains("marginRight")
        let includeFontSizeBool = tmpStyleEntry.keys.contains("fontSize")
        let includeLineHeightBool = tmpStyleEntry.keys.contains("lineHeight")
        let includeFontWeightBool = tmpStyleEntry.keys.contains("fontWeight")
        let includeColorBool = tmpStyleEntry.keys.contains("color")
        let includeTextAlignBool = tmpStyleEntry.keys.contains("textAlign")
        let includeTextDecorationBool = tmpStyleEntry.keys.contains("textDecoration")
        let includeTextTransformBool = tmpStyleEntry.keys.contains("textTransform")
        let includeTextOverflowBool = tmpStyleEntry.keys.contains("textOverflow")
        let includeOverflowWrapBool = tmpStyleEntry.keys.contains("overflowWrap")
        let includeWordBreakBool = tmpStyleEntry.keys.contains("wordBreak")
        let includePositionBool = tmpStyleEntry.keys.contains("position")
        let includeTopBool = tmpStyleEntry.keys.contains("top")
        let includeLeftBool = tmpStyleEntry.keys.contains("left")
        let includeBottomBool = tmpStyleEntry.keys.contains("bottom")
        let includeRightBool = tmpStyleEntry.keys.contains("right")
        let includeZIndexBool = tmpStyleEntry.keys.contains("zIndex")
        let includeDisplayBool = tmpStyleEntry.keys.contains("display")
        let includePointerEventsBool = tmpStyleEntry.keys.contains("pointerEvents")
        let includeObjectFitBool = tmpStyleEntry.keys.contains("objectFit")
        let includeOverflowBool = tmpStyleEntry.keys.contains("overflow")
        let includeOpacityBool = tmpStyleEntry.keys.contains("opacity")
        let includeAspectRatioBool = tmpStyleEntry.keys.contains("aspectRatio")
        let includeBorderRadiusBool = tmpStyleEntry.keys.contains("borderRadius")
        let includeBorderRadiusTopLeftBool = tmpStyleEntry.keys.contains("borderRadiusTopLeft")
        let includeBorderRadiusTopRightBool = tmpStyleEntry.keys.contains("borderRadiusTopRight")
        let includeBorderRadiusBottomLeftBool = tmpStyleEntry.keys.contains("borderRadiusBottomLeft")
        let includeBorderRadiusBottomRightBool = tmpStyleEntry.keys.contains("borderRadiusBottomRight")
        let includeBorderWidthBool = tmpStyleEntry.keys.contains("borderWidth")
        let includeBorderColorBool = tmpStyleEntry.keys.contains("borderColor")
        let includeBorderTopWidthBool = tmpStyleEntry.keys.contains("borderTopWidth")
        let includeBorderTopColorBool = tmpStyleEntry.keys.contains("borderTopColor")
        let includeBorderLeftWidthBool = tmpStyleEntry.keys.contains("borderLeftWidth")
        let includeBorderLeftColorBool = tmpStyleEntry.keys.contains("borderLeftColor")
        let includeBorderBottomWidthBool = tmpStyleEntry.keys.contains("borderBottomWidth")
        let includeBorderBottomColorBool = tmpStyleEntry.keys.contains("borderBottomColor")
        let includeBorderRightWidthBool = tmpStyleEntry.keys.contains("borderRightWidth")
        let includeBorderRightColorBool = tmpStyleEntry.keys.contains("borderRightColor")
        let includeTransformBool = tmpStyleEntry.keys.contains("transform")
        
        if includeFlexBool {
            styleEntry.style.flex = tmpStyleEntry.style.flex
        }
        
        if includeFlexDirectionBool {
            styleEntry.style.flexDirection = tmpStyleEntry.style.flexDirection
        }
        
        if includeJustifyContentBool {
            styleEntry.style.justifyContent = tmpStyleEntry.style.justifyContent
        }
        
        if includeAlignItemsBool {
            styleEntry.style.alignItems = tmpStyleEntry.style.alignItems
        }
        
        if includeAlignSelfBool {
            styleEntry.style.alignSelf = tmpStyleEntry.style.alignSelf
        }
        
        if includeGapBool {
            styleEntry.style.gap = tmpStyleEntry.style.gap
        }
        
        if includeBackgroundColorBool {
            styleEntry.style.backgroundColor = tmpStyleEntry.style.backgroundColor
        }

        if includeWidthBool {
            styleEntry.style.width = tmpStyleEntry.style.width
        }

        if includeHeightBool {
            styleEntry.style.height = tmpStyleEntry.style.height
        }

        if includeMinWidthBool {
            styleEntry.style.minWidth = tmpStyleEntry.style.minWidth
        }

        if includeMinHeightBool {
            styleEntry.style.minHeight = tmpStyleEntry.style.minHeight
        }

        if includeMaxWidthBool {
            styleEntry.style.maxWidth = tmpStyleEntry.style.maxWidth
        }

        if includeMaxHeightBool {
            styleEntry.style.maxHeight = tmpStyleEntry.style.maxHeight
        }

        if includePaddingBool {
            styleEntry.style.padding = tmpStyleEntry.style.padding
        }

        if includePaddingHorizontalBool {
            styleEntry.style.paddingHorizontal = tmpStyleEntry.style.paddingHorizontal
        }

        if includePaddingVerticalBool {
            styleEntry.style.paddingVertical = tmpStyleEntry.style.paddingVertical
        }

        if includePaddingTopBool {
            styleEntry.style.paddingTop = tmpStyleEntry.style.paddingTop
        }

        if includePaddingLeftBool {
            styleEntry.style.paddingLeft = tmpStyleEntry.style.paddingLeft
        }

        if includePaddingBottomBool {
            styleEntry.style.paddingBottom = tmpStyleEntry.style.paddingBottom
        }

        if includePaddingRightBool {
            styleEntry.style.paddingRight = tmpStyleEntry.style.paddingRight
        }

        if includeMarginBool {
            styleEntry.style.margin = tmpStyleEntry.style.margin
        }

        if includeMarginHorizontalBool {
            styleEntry.style.marginHorizontal = tmpStyleEntry.style.marginHorizontal
        }

        if includeMarginVerticalBool {
            styleEntry.style.marginVertical = tmpStyleEntry.style.marginVertical
        }

        if includeMarginTopBool {
            styleEntry.style.marginTop = tmpStyleEntry.style.marginTop
        }

        if includeMarginLeftBool {
            styleEntry.style.marginLeft = tmpStyleEntry.style.marginLeft
        }

        if includeMarginBottomBool {
            styleEntry.style.marginBottom = tmpStyleEntry.style.marginBottom
        }

        if includeMarginRightBool {
            styleEntry.style.marginRight = tmpStyleEntry.style.marginRight
        }

        if includeFontSizeBool {
            styleEntry.style.fontSize = tmpStyleEntry.style.fontSize
        }

        if includeLineHeightBool {
            styleEntry.style.lineHeight = tmpStyleEntry.style.lineHeight
        }

        if includeFontWeightBool {
            styleEntry.style.fontWeight = tmpStyleEntry.style.fontWeight
        }

        if includeColorBool {
            styleEntry.style.color = tmpStyleEntry.style.color
        }

        if includeTextAlignBool {
            styleEntry.style.textAlign = tmpStyleEntry.style.textAlign
        }

        if includeTextDecorationBool {
            styleEntry.style.textDecoration = tmpStyleEntry.style.textDecoration
        }

        if includeTextTransformBool {
            styleEntry.style.textTransform = tmpStyleEntry.style.textTransform
        }

        if includeTextOverflowBool {
            styleEntry.style.textOverflow = tmpStyleEntry.style.textOverflow
        }

        if includeOverflowWrapBool {
            styleEntry.style.overflowWrap = tmpStyleEntry.style.overflowWrap
        }

        if includeWordBreakBool {
            styleEntry.style.wordBreak = tmpStyleEntry.style.wordBreak
        }

        if includePositionBool {
            styleEntry.style.position = tmpStyleEntry.style.position
        }

        if includeTopBool {
            styleEntry.style.top = tmpStyleEntry.style.top
        }

        if includeLeftBool {
            styleEntry.style.left = tmpStyleEntry.style.left
        }

        if includeBottomBool {
            styleEntry.style.bottom = tmpStyleEntry.style.bottom
        }

        if includeRightBool {
            styleEntry.style.right = tmpStyleEntry.style.right
        }

        if includeZIndexBool {
            styleEntry.style.zIndex = tmpStyleEntry.style.zIndex
        }

        if includeDisplayBool {
            styleEntry.style.display = tmpStyleEntry.style.display
        }

        if includePointerEventsBool {
            styleEntry.style.pointerEvents = tmpStyleEntry.style.pointerEvents
        }

        if includeObjectFitBool {
            styleEntry.style.objectFit = tmpStyleEntry.style.objectFit
        }

        if includeOverflowBool {
            styleEntry.style.overflow = tmpStyleEntry.style.overflow
        }

        if includeOpacityBool {
            styleEntry.style.opacity = tmpStyleEntry.style.opacity
        }

        if includeAspectRatioBool {
            styleEntry.style.aspectRatio = tmpStyleEntry.style.aspectRatio
        }

        if includeBorderRadiusBool {
            styleEntry.style.borderRadius = tmpStyleEntry.style.borderRadius
        }

        if includeBorderRadiusTopLeftBool {
            styleEntry.style.borderRadiusTopLeft = tmpStyleEntry.style.borderRadiusTopLeft
        }

        if includeBorderRadiusTopRightBool {
            styleEntry.style.borderRadiusTopRight = tmpStyleEntry.style.borderRadiusTopRight
        }

        if includeBorderRadiusBottomLeftBool {
            styleEntry.style.borderRadiusBottomLeft = tmpStyleEntry.style.borderRadiusBottomLeft
        }

        if includeBorderRadiusBottomRightBool {
            styleEntry.style.borderRadiusBottomRight = tmpStyleEntry.style.borderRadiusBottomRight
        }

        if includeBorderWidthBool {
            styleEntry.style.borderWidth = tmpStyleEntry.style.borderWidth
        }

        if includeBorderColorBool {
            styleEntry.style.borderColor = tmpStyleEntry.style.borderColor
        }

        if includeBorderTopWidthBool {
            styleEntry.style.borderTopWidth = tmpStyleEntry.style.borderTopWidth
        }

        if includeBorderTopColorBool {
            styleEntry.style.borderTopColor = tmpStyleEntry.style.borderTopColor
        }

        if includeBorderLeftWidthBool {
            styleEntry.style.borderLeftWidth = tmpStyleEntry.style.borderLeftWidth
        }

        if includeBorderLeftColorBool {
            styleEntry.style.borderLeftColor = tmpStyleEntry.style.borderLeftColor
        }

        if includeBorderBottomWidthBool {
            styleEntry.style.borderBottomWidth = tmpStyleEntry.style.borderBottomWidth
        }

        if includeBorderBottomColorBool {
            styleEntry.style.borderBottomColor = tmpStyleEntry.style.borderBottomColor
        }

        if includeBorderRightWidthBool {
            styleEntry.style.borderRightWidth = tmpStyleEntry.style.borderRightWidth
        }

        if includeBorderRightColorBool {
            styleEntry.style.borderRightColor = tmpStyleEntry.style.borderRightColor
        }

        if includeTransformBool {
            styleEntry.style.transform = tmpStyleEntry.style.transform
        }
    }
    
    public static func fillStyleEntry(styleEntry: StyleEntry, tmpStyleEntries: [StyleEntry]) -> Void {
        for tmpStyleEntry in tmpStyleEntries {
            fillStyleEntry(styleEntry: styleEntry, tmpStyleEntry: tmpStyleEntry)
        }
    }
    
    public static func removeStyleEntryKeys(styleEntry: StyleEntry, keys: [String]) -> Void {
        for key in keys {
            if !styleEntry.keys.contains(key) {
                continue
            }
            
            let index = styleEntry.keys.firstIndex(of: key)!
            
            styleEntry.keys.remove(at: index)
        }
        
        let excludeFlexBool = keys.contains("flex")
        let excludeFlexDirectionBool = keys.contains("flexDirection")
        let excludeJustifyContentBool = keys.contains("justifyContent")
        let excludeAlignItemsBool = keys.contains("alignItems")
        let excludeAlignSelfBool = keys.contains("alignSelf")
        let excludeGapBool = keys.contains("gap")
        let excludeBackgroundColorBool = keys.contains("backgroundColor")
        let excludeWidthBool = keys.contains("width")
        let excludeHeightBool = keys.contains("height")
        let excludeMinWidthBool = keys.contains("minWidth")
        let excludeMinHeightBool = keys.contains("minHeight")
        let excludeMaxWidthBool = keys.contains("maxWidth")
        let excludeMaxHeightBool = keys.contains("maxHeight")
        let excludePaddingBool = keys.contains("padding")
        let excludePaddingHorizontalBool = keys.contains("paddingHorizontal")
        let excludePaddingVerticalBool = keys.contains("paddingVertical")
        let excludePaddingTopBool = keys.contains("paddingTop")
        let excludePaddingLeftBool = keys.contains("paddingLeft")
        let excludePaddingBottomBool = keys.contains("paddingBottom")
        let excludePaddingRightBool = keys.contains("paddingRight")
        let excludeMarginBool = keys.contains("margin")
        let excludeMarginHorizontalBool = keys.contains("marginHorizontal")
        let excludeMarginVerticalBool = keys.contains("marginVertical")
        let excludeMarginTopBool = keys.contains("marginTop")
        let excludeMarginLeftBool = keys.contains("marginLeft")
        let excludeMarginBottomBool = keys.contains("marginBottom")
        let excludeMarginRightBool = keys.contains("marginRight")
        let excludeFontSizeBool = keys.contains("fontSize")
        let excludeLineHeightBool = keys.contains("lineHeight")
        let excludeFontWeightBool = keys.contains("fontWeight")
        let excludeColorBool = keys.contains("color")
        let excludeTextAlignBool = keys.contains("textAlign")
        let excludeTextDecorationBool = keys.contains("textDecoration")
        let excludeTextTransformBool = keys.contains("textTransform")
        let excludeTextOverflowBool = keys.contains("textOverflow")
        let excludeOverflowWrapBool = keys.contains("overflowWrap")
        let excludeWordBreakBool = keys.contains("wordBreak")
        let excludePositionBool = keys.contains("position")
        let excludeTopBool = keys.contains("top")
        let excludeLeftBool = keys.contains("left")
        let excludeBottomBool = keys.contains("bottom")
        let excludeRightBool = keys.contains("right")
        let excludeZIndexBool = keys.contains("zIndex")
        let excludeDisplayBool = keys.contains("display")
        let excludePointerEventsBool = keys.contains("pointerEvents")
        let excludeObjectFitBool = keys.contains("objectFit")
        let excludeOverflowBool = keys.contains("overflow")
        let excludeOpacityBool = keys.contains("opacity")
        let excludeAspectRatioBool = keys.contains("aspectRatio")
        let excludeBorderRadiusBool = keys.contains("borderRadius")
        let excludeBorderRadiusTopLeftBool = keys.contains("borderRadiusTopLeft")
        let excludeBorderRadiusTopRightBool = keys.contains("borderRadiusTopRight")
        let excludeBorderRadiusBottomLeftBool = keys.contains("borderRadiusBottomLeft")
        let excludeBorderRadiusBottomRightBool = keys.contains("borderRadiusBottomRight")
        let excludeBorderWidthBool = keys.contains("borderWidth")
        let excludeBorderColorBool = keys.contains("borderColor")
        let excludeBorderTopWidthBool = keys.contains("borderTopWidth")
        let excludeBorderTopColorBool = keys.contains("borderTopColor")
        let excludeBorderLeftWidthBool = keys.contains("borderLeftWidth")
        let excludeBorderLeftColorBool = keys.contains("borderLeftColor")
        let excludeBorderBottomWidthBool = keys.contains("borderBottomWidth")
        let excludeBorderBottomColorBool = keys.contains("borderBottomColor")
        let excludeBorderRightWidthBool = keys.contains("borderRightWidth")
        let excludeBorderRightColorBool = keys.contains("borderRightColor")
        let excludeTransformBool = keys.contains("transform")

        if excludeFlexBool {
            styleEntry.style.flex = nil
        }

        if excludeFlexDirectionBool {
            styleEntry.style.flexDirection = nil
        }

        if excludeJustifyContentBool {
            styleEntry.style.justifyContent = nil
        }

        if excludeAlignItemsBool {
            styleEntry.style.alignItems = nil
        }

        if excludeAlignSelfBool {
            styleEntry.style.alignSelf = nil
        }
        
        if excludeGapBool {
            styleEntry.style.gap = nil
        }

        if excludeBackgroundColorBool {
            styleEntry.style.backgroundColor = nil
        }
        
        if excludeWidthBool {
            styleEntry.style.width = nil
        }

        if excludeHeightBool {
            styleEntry.style.height = nil
        }

        if excludeMinWidthBool {
            styleEntry.style.minWidth = nil
        }

        if excludeMinHeightBool {
            styleEntry.style.minHeight = nil
        }

        if excludeMaxWidthBool {
            styleEntry.style.maxWidth = nil
        }

        if excludeMaxHeightBool {
            styleEntry.style.maxHeight = nil
        }

        if excludePaddingBool {
            styleEntry.style.padding = nil
        }

        if excludePaddingHorizontalBool {
            styleEntry.style.paddingHorizontal = nil
        }

        if excludePaddingVerticalBool {
            styleEntry.style.paddingVertical = nil
        }

        if excludePaddingTopBool {
            styleEntry.style.paddingTop = nil
        }

        if excludePaddingLeftBool {
            styleEntry.style.paddingLeft = nil
        }

        if excludePaddingBottomBool {
            styleEntry.style.paddingBottom = nil
        }

        if excludePaddingRightBool {
            styleEntry.style.paddingRight = nil
        }

        if excludeMarginBool {
            styleEntry.style.margin = nil
        }

        if excludeMarginHorizontalBool {
            styleEntry.style.marginHorizontal = nil
        }

        if excludeMarginVerticalBool {
            styleEntry.style.marginVertical = nil
        }

        if excludeMarginTopBool {
            styleEntry.style.marginTop = nil
        }

        if excludeMarginLeftBool {
            styleEntry.style.marginLeft = nil
        }

        if excludeMarginBottomBool {
            styleEntry.style.marginBottom = nil
        }

        if excludeMarginRightBool {
            styleEntry.style.marginRight = nil
        }

        if excludeFontSizeBool {
            styleEntry.style.fontSize = nil
        }

        if excludeLineHeightBool {
            styleEntry.style.lineHeight = nil
        }

        if excludeFontWeightBool {
            styleEntry.style.fontWeight = nil
        }

        if excludeColorBool {
            styleEntry.style.color = nil
        }

        if excludeTextAlignBool {
            styleEntry.style.textAlign = nil
        }

        if excludeTextDecorationBool {
            styleEntry.style.textDecoration = nil
        }

        if excludeTextTransformBool {
            styleEntry.style.textTransform = nil
        }

        if excludeTextOverflowBool {
            styleEntry.style.textOverflow = nil
        }

        if excludeOverflowWrapBool {
            styleEntry.style.overflowWrap = nil
        }

        if excludeWordBreakBool {
            styleEntry.style.wordBreak = nil
        }

        if excludePositionBool {
            styleEntry.style.position = nil
        }

        if excludeTopBool {
            styleEntry.style.top = nil
        }

        if excludeLeftBool {
            styleEntry.style.left = nil
        }

        if excludeBottomBool {
            styleEntry.style.bottom = nil
        }

        if excludeRightBool {
            styleEntry.style.right = nil
        }

        if excludeZIndexBool {
            styleEntry.style.zIndex = nil
        }

        if excludeDisplayBool {
            styleEntry.style.display = nil
        }

        if excludePointerEventsBool {
            styleEntry.style.pointerEvents = nil
        }

        if excludeObjectFitBool {
            styleEntry.style.objectFit = nil
        }

        if excludeOverflowBool {
            styleEntry.style.overflow = nil
        }

        if excludeOpacityBool {
            styleEntry.style.opacity = nil
        }

        if excludeAspectRatioBool {
            styleEntry.style.aspectRatio = nil
        }

        if excludeBorderRadiusBool {
            styleEntry.style.borderRadius = nil
        }

        if excludeBorderRadiusTopLeftBool {
            styleEntry.style.borderRadiusTopLeft = nil
        }

        if excludeBorderRadiusTopRightBool {
            styleEntry.style.borderRadiusTopRight = nil
        }

        if excludeBorderRadiusBottomLeftBool {
            styleEntry.style.borderRadiusBottomLeft = nil
        }

        if excludeBorderRadiusBottomRightBool {
            styleEntry.style.borderRadiusBottomRight = nil
        }

        if excludeBorderWidthBool {
            styleEntry.style.borderWidth = nil
        }

        if excludeBorderColorBool {
            styleEntry.style.borderColor = nil
        }

        if excludeBorderTopWidthBool {
            styleEntry.style.borderTopWidth = nil
        }

        if excludeBorderTopColorBool {
            styleEntry.style.borderTopColor = nil
        }

        if excludeBorderLeftWidthBool {
            styleEntry.style.borderLeftWidth = nil
        }

        if excludeBorderLeftColorBool {
            styleEntry.style.borderLeftColor = nil
        }

        if excludeBorderBottomWidthBool {
            styleEntry.style.borderBottomWidth = nil
        }

        if excludeBorderBottomColorBool {
            styleEntry.style.borderBottomColor = nil
        }

        if excludeBorderRightWidthBool {
            styleEntry.style.borderRightWidth = nil
        }

        if excludeBorderRightColorBool {
            styleEntry.style.borderRightColor = nil
        }

        if excludeTransformBool {
            styleEntry.style.transform = nil
        }
    }
}
