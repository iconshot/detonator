package com.iconshot.detonator.module.stylesheet;

import java.util.List;

public class StyleSheetHelper {
    public static void fillStyle(Style style, StyleEntry styleEntry) {
        boolean includeFlex = styleEntry.keys.contains("flex");
        boolean includeFlexDirection = styleEntry.keys.contains("flexDirection");
        boolean includeJustifyContent = styleEntry.keys.contains("justifyContent");
        boolean includeAlignItems = styleEntry.keys.contains("alignItems");
        boolean includeAlignSelf = styleEntry.keys.contains("alignSelf");
        boolean includeGap = styleEntry.keys.contains("gap");
        boolean includeBackgroundColor = styleEntry.keys.contains("backgroundColor");
        boolean includeWidth = styleEntry.keys.contains("width");
        boolean includeHeight = styleEntry.keys.contains("height");
        boolean includeMinWidth = styleEntry.keys.contains("minWidth");
        boolean includeMinHeight = styleEntry.keys.contains("minHeight");
        boolean includeMaxWidth = styleEntry.keys.contains("maxWidth");
        boolean includeMaxHeight = styleEntry.keys.contains("maxHeight");
        boolean includePadding = styleEntry.keys.contains("padding");
        boolean includePaddingHorizontal = styleEntry.keys.contains("paddingHorizontal");
        boolean includePaddingVertical = styleEntry.keys.contains("paddingVertical");
        boolean includePaddingTop = styleEntry.keys.contains("paddingTop");
        boolean includePaddingLeft = styleEntry.keys.contains("paddingLeft");
        boolean includePaddingBottom = styleEntry.keys.contains("paddingBottom");
        boolean includePaddingRight = styleEntry.keys.contains("paddingRight");
        boolean includeMargin = styleEntry.keys.contains("margin");
        boolean includeMarginHorizontal = styleEntry.keys.contains("marginHorizontal");
        boolean includeMarginVertical = styleEntry.keys.contains("marginVertical");
        boolean includeMarginTop = styleEntry.keys.contains("marginTop");
        boolean includeMarginLeft = styleEntry.keys.contains("marginLeft");
        boolean includeMarginBottom = styleEntry.keys.contains("marginBottom");
        boolean includeMarginRight = styleEntry.keys.contains("marginRight");
        boolean includeFontSize = styleEntry.keys.contains("fontSize");
        boolean includeLineHeight = styleEntry.keys.contains("lineHeight");
        boolean includeFontWeight = styleEntry.keys.contains("fontWeight");
        boolean includeColor = styleEntry.keys.contains("color");
        boolean includeTextAlign = styleEntry.keys.contains("textAlign");
        boolean includeTextDecoration = styleEntry.keys.contains("textDecoration");
        boolean includeTextTransform = styleEntry.keys.contains("textTransform");
        boolean includeTextOverflow = styleEntry.keys.contains("textOverflow");
        boolean includeOverflowWrap = styleEntry.keys.contains("overflowWrap");
        boolean includeWordBreak = styleEntry.keys.contains("wordBreak");
        boolean includePosition = styleEntry.keys.contains("position");
        boolean includeTop = styleEntry.keys.contains("top");
        boolean includeLeft = styleEntry.keys.contains("left");
        boolean includeBottom = styleEntry.keys.contains("bottom");
        boolean includeRight = styleEntry.keys.contains("right");
        boolean includeZIndex = styleEntry.keys.contains("zIndex");
        boolean includeDisplay = styleEntry.keys.contains("display");
        boolean includePointerEvents = styleEntry.keys.contains("pointerEvents");
        boolean includeObjectFit = styleEntry.keys.contains("objectFit");
        boolean includeOverflow = styleEntry.keys.contains("overflow");
        boolean includeOpacity = styleEntry.keys.contains("opacity");
        boolean includeAspectRatio = styleEntry.keys.contains("aspectRatio");
        boolean includeBorderRadius = styleEntry.keys.contains("borderRadius");
        boolean includeBorderRadiusTopLeft = styleEntry.keys.contains("borderRadiusTopLeft");
        boolean includeBorderRadiusTopRight = styleEntry.keys.contains("borderRadiusTopRight");
        boolean includeBorderRadiusBottomLeft = styleEntry.keys.contains("borderRadiusBottomLeft");
        boolean includeBorderRadiusBottomRight = styleEntry.keys.contains("borderRadiusBottomRight");
        boolean includeBorderWidth = styleEntry.keys.contains("borderWidth");
        boolean includeBorderColor = styleEntry.keys.contains("borderColor");
        boolean includeBorderTopWidth = styleEntry.keys.contains("borderTopWidth");
        boolean includeBorderTopColor = styleEntry.keys.contains("borderTopColor");
        boolean includeBorderLeftWidth = styleEntry.keys.contains("borderLeftWidth");
        boolean includeBorderLeftColor = styleEntry.keys.contains("borderLeftColor");
        boolean includeBorderBottomWidth = styleEntry.keys.contains("borderBottomWidth");
        boolean includeBorderBottomColor = styleEntry.keys.contains("borderBottomColor");
        boolean includeBorderRightWidth = styleEntry.keys.contains("borderRightWidth");
        boolean includeBorderRightColor = styleEntry.keys.contains("borderRightColor");
        boolean includeTransform = styleEntry.keys.contains("transform");

        if (includeFlex) {
            style.flex = styleEntry.style.flex;
        }

        if (includeFlexDirection) {
            style.flexDirection = styleEntry.style.flexDirection;
        }

        if (includeJustifyContent) {
            style.justifyContent = styleEntry.style.justifyContent;
        }

        if (includeAlignItems) {
            style.alignItems = styleEntry.style.alignItems;
        }

        if (includeAlignSelf) {
            style.alignSelf = styleEntry.style.alignSelf;
        }

        if (includeGap) {
            style.gap = styleEntry.style.gap;
        }

        if (includeBackgroundColor) {
            style.backgroundColor = styleEntry.style.backgroundColor;
        }

        if (includeWidth) {
            style.width = styleEntry.style.width;
        }

        if (includeHeight) {
            style.height = styleEntry.style.height;
        }

        if (includeMinWidth) {
            style.minWidth = styleEntry.style.minWidth;
        }

        if (includeMinHeight) {
            style.minHeight = styleEntry.style.minHeight;
        }

        if (includeMaxWidth) {
            style.maxWidth = styleEntry.style.maxWidth;
        }

        if (includeMaxHeight) {
            style.maxHeight = styleEntry.style.maxHeight;
        }

        if (includePadding) {
            style.padding = styleEntry.style.padding;
        }

        if (includePaddingHorizontal) {
            style.paddingHorizontal = styleEntry.style.paddingHorizontal;
        }

        if (includePaddingVertical) {
            style.paddingVertical = styleEntry.style.paddingVertical;
        }

        if (includePaddingTop) {
            style.paddingTop = styleEntry.style.paddingTop;
        }

        if (includePaddingLeft) {
            style.paddingLeft = styleEntry.style.paddingLeft;
        }

        if (includePaddingBottom) {
            style.paddingBottom = styleEntry.style.paddingBottom;
        }

        if (includePaddingRight) {
            style.paddingRight = styleEntry.style.paddingRight;
        }

        if (includeMargin) {
            style.margin = styleEntry.style.margin;
        }

        if (includeMarginHorizontal) {
            style.marginHorizontal = styleEntry.style.marginHorizontal;
        }

        if (includeMarginVertical) {
            style.marginVertical = styleEntry.style.marginVertical;
        }

        if (includeMarginTop) {
            style.marginTop = styleEntry.style.marginTop;
        }

        if (includeMarginLeft) {
            style.marginLeft = styleEntry.style.marginLeft;
        }

        if (includeMarginBottom) {
            style.marginBottom = styleEntry.style.marginBottom;
        }

        if (includeMarginRight) {
            style.marginRight = styleEntry.style.marginRight;
        }

        if (includeFontSize) {
            style.fontSize = styleEntry.style.fontSize;
        }

        if (includeLineHeight) {
            style.lineHeight = styleEntry.style.lineHeight;
        }

        if (includeFontWeight) {
            style.fontWeight = styleEntry.style.fontWeight;
        }

        if (includeColor) {
            style.color = styleEntry.style.color;
        }

        if (includeTextAlign) {
            style.textAlign = styleEntry.style.textAlign;
        }

        if (includeTextDecoration) {
            style.textDecoration = styleEntry.style.textDecoration;
        }

        if (includeTextTransform) {
            style.textTransform = styleEntry.style.textTransform;
        }

        if (includeTextOverflow) {
            style.textOverflow = styleEntry.style.textOverflow;
        }

        if (includeOverflowWrap) {
            style.overflowWrap = styleEntry.style.overflowWrap;
        }

        if (includeWordBreak) {
            style.wordBreak = styleEntry.style.wordBreak;
        }

        if (includePosition) {
            style.position = styleEntry.style.position;
        }

        if (includeTop) {
            style.top = styleEntry.style.top;
        }

        if (includeLeft) {
            style.left = styleEntry.style.left;
        }

        if (includeBottom) {
            style.bottom = styleEntry.style.bottom;
        }

        if (includeRight) {
            style.right = styleEntry.style.right;
        }

        if (includeZIndex) {
            style.zIndex = styleEntry.style.zIndex;
        }

        if (includeDisplay) {
            style.display = styleEntry.style.display;
        }

        if (includePointerEvents) {
            style.pointerEvents = styleEntry.style.pointerEvents;
        }

        if (includeObjectFit) {
            style.objectFit = styleEntry.style.objectFit;
        }

        if (includeOverflow) {
            style.overflow = styleEntry.style.overflow;
        }

        if (includeOpacity) {
            style.opacity = styleEntry.style.opacity;
        }

        if (includeAspectRatio) {
            style.aspectRatio = styleEntry.style.aspectRatio;
        }

        if (includeBorderRadius) {
            style.borderRadius = styleEntry.style.borderRadius;
        }

        if (includeBorderRadiusTopLeft) {
            style.borderRadiusTopLeft = styleEntry.style.borderRadiusTopLeft;
        }

        if (includeBorderRadiusTopRight) {
            style.borderRadiusTopRight = styleEntry.style.borderRadiusTopRight;
        }

        if (includeBorderRadiusBottomLeft) {
            style.borderRadiusBottomLeft = styleEntry.style.borderRadiusBottomLeft;
        }

        if (includeBorderRadiusBottomRight) {
            style.borderRadiusBottomRight = styleEntry.style.borderRadiusBottomRight;
        }

        if (includeBorderWidth) {
            style.borderWidth = styleEntry.style.borderWidth;
        }

        if (includeBorderColor) {
            style.borderColor = styleEntry.style.borderColor;
        }

        if (includeBorderTopWidth) {
            style.borderTopWidth = styleEntry.style.borderTopWidth;
        }

        if (includeBorderTopColor) {
            style.borderTopColor = styleEntry.style.borderTopColor;
        }

        if (includeBorderLeftWidth) {
            style.borderLeftWidth = styleEntry.style.borderLeftWidth;
        }

        if (includeBorderLeftColor) {
            style.borderLeftColor = styleEntry.style.borderLeftColor;
        }

        if (includeBorderBottomWidth) {
            style.borderBottomWidth = styleEntry.style.borderBottomWidth;
        }

        if (includeBorderBottomColor) {
            style.borderBottomColor = styleEntry.style.borderBottomColor;
        }

        if (includeBorderRightWidth) {
            style.borderRightWidth = styleEntry.style.borderRightWidth;
        }

        if (includeBorderRightColor) {
            style.borderRightColor = styleEntry.style.borderRightColor;
        }

        if (includeTransform) {
            style.transform = styleEntry.style.transform;
        }
    }

    public static void fillStyle(Style style, List<StyleEntry> styleEntries) {
        for (StyleEntry styleEntry : styleEntries) {
            fillStyle(style, styleEntry);
        }
    }

    public static Style createStyle(List<StyleEntry> styleEntries) {
        Style style = new Style();

        fillStyle(style, styleEntries);

        return style;
    }

    public static void fillStyleEntry(StyleEntry styleEntry, StyleEntry tmpStyleEntry) {
        for (String tmpKey : tmpStyleEntry.keys) {
            if (styleEntry.keys.contains(tmpKey)) {
                continue;
            }

            styleEntry.keys.add(tmpKey);
        }

        boolean includeFlex = tmpStyleEntry.keys.contains("flex");
        boolean includeFlexDirection = tmpStyleEntry.keys.contains("flexDirection");
        boolean includeJustifyContent = tmpStyleEntry.keys.contains("justifyContent");
        boolean includeAlignItems = tmpStyleEntry.keys.contains("alignItems");
        boolean includeAlignSelf = tmpStyleEntry.keys.contains("alignSelf");
        boolean includeGap = tmpStyleEntry.keys.contains("gap");
        boolean includeBackgroundColor = tmpStyleEntry.keys.contains("backgroundColor");
        boolean includeWidth = tmpStyleEntry.keys.contains("width");
        boolean includeHeight = tmpStyleEntry.keys.contains("height");
        boolean includeMinWidth = tmpStyleEntry.keys.contains("minWidth");
        boolean includeMinHeight = tmpStyleEntry.keys.contains("minHeight");
        boolean includeMaxWidth = tmpStyleEntry.keys.contains("maxWidth");
        boolean includeMaxHeight = tmpStyleEntry.keys.contains("maxHeight");
        boolean includePadding = tmpStyleEntry.keys.contains("padding");
        boolean includePaddingHorizontal = tmpStyleEntry.keys.contains("paddingHorizontal");
        boolean includePaddingVertical = tmpStyleEntry.keys.contains("paddingVertical");
        boolean includePaddingTop = tmpStyleEntry.keys.contains("paddingTop");
        boolean includePaddingLeft = tmpStyleEntry.keys.contains("paddingLeft");
        boolean includePaddingBottom = tmpStyleEntry.keys.contains("paddingBottom");
        boolean includePaddingRight = tmpStyleEntry.keys.contains("paddingRight");
        boolean includeMargin = tmpStyleEntry.keys.contains("margin");
        boolean includeMarginHorizontal = tmpStyleEntry.keys.contains("marginHorizontal");
        boolean includeMarginVertical = tmpStyleEntry.keys.contains("marginVertical");
        boolean includeMarginTop = tmpStyleEntry.keys.contains("marginTop");
        boolean includeMarginLeft = tmpStyleEntry.keys.contains("marginLeft");
        boolean includeMarginBottom = tmpStyleEntry.keys.contains("marginBottom");
        boolean includeMarginRight = tmpStyleEntry.keys.contains("marginRight");
        boolean includeFontSize = tmpStyleEntry.keys.contains("fontSize");
        boolean includeLineHeight = tmpStyleEntry.keys.contains("lineHeight");
        boolean includeFontWeight = tmpStyleEntry.keys.contains("fontWeight");
        boolean includeColor = tmpStyleEntry.keys.contains("color");
        boolean includeTextAlign = tmpStyleEntry.keys.contains("textAlign");
        boolean includeTextDecoration = tmpStyleEntry.keys.contains("textDecoration");
        boolean includeTextTransform = tmpStyleEntry.keys.contains("textTransform");
        boolean includeTextOverflow = tmpStyleEntry.keys.contains("textOverflow");
        boolean includeOverflowWrap = tmpStyleEntry.keys.contains("overflowWrap");
        boolean includeWordBreak = tmpStyleEntry.keys.contains("wordBreak");
        boolean includePosition = tmpStyleEntry.keys.contains("position");
        boolean includeTop = tmpStyleEntry.keys.contains("top");
        boolean includeLeft = tmpStyleEntry.keys.contains("left");
        boolean includeBottom = tmpStyleEntry.keys.contains("bottom");
        boolean includeRight = tmpStyleEntry.keys.contains("right");
        boolean includeZIndex = tmpStyleEntry.keys.contains("zIndex");
        boolean includeDisplay = tmpStyleEntry.keys.contains("display");
        boolean includePointerEvents = tmpStyleEntry.keys.contains("pointerEvents");
        boolean includeObjectFit = tmpStyleEntry.keys.contains("objectFit");
        boolean includeOverflow = tmpStyleEntry.keys.contains("overflow");
        boolean includeOpacity = tmpStyleEntry.keys.contains("opacity");
        boolean includeAspectRatio = tmpStyleEntry.keys.contains("aspectRatio");
        boolean includeBorderRadius = tmpStyleEntry.keys.contains("borderRadius");
        boolean includeBorderRadiusTopLeft = tmpStyleEntry.keys.contains("borderRadiusTopLeft");
        boolean includeBorderRadiusTopRight = tmpStyleEntry.keys.contains("borderRadiusTopRight");
        boolean includeBorderRadiusBottomLeft = tmpStyleEntry.keys.contains("borderRadiusBottomLeft");
        boolean includeBorderRadiusBottomRight = tmpStyleEntry.keys.contains("borderRadiusBottomRight");
        boolean includeBorderWidth = tmpStyleEntry.keys.contains("borderWidth");
        boolean includeBorderColor = tmpStyleEntry.keys.contains("borderColor");
        boolean includeBorderTopWidth = tmpStyleEntry.keys.contains("borderTopWidth");
        boolean includeBorderTopColor = tmpStyleEntry.keys.contains("borderTopColor");
        boolean includeBorderLeftWidth = tmpStyleEntry.keys.contains("borderLeftWidth");
        boolean includeBorderLeftColor = tmpStyleEntry.keys.contains("borderLeftColor");
        boolean includeBorderBottomWidth = tmpStyleEntry.keys.contains("borderBottomWidth");
        boolean includeBorderBottomColor = tmpStyleEntry.keys.contains("borderBottomColor");
        boolean includeBorderRightWidth = tmpStyleEntry.keys.contains("borderRightWidth");
        boolean includeBorderRightColor = tmpStyleEntry.keys.contains("borderRightColor");
        boolean includeTransform = tmpStyleEntry.keys.contains("transform");

        if (includeFlex) {
            styleEntry.style.flex = tmpStyleEntry.style.flex;
        }

        if (includeFlexDirection) {
            styleEntry.style.flexDirection = tmpStyleEntry.style.flexDirection;
        }

        if (includeJustifyContent) {
            styleEntry.style.justifyContent = tmpStyleEntry.style.justifyContent;
        }

        if (includeAlignItems) {
            styleEntry.style.alignItems = tmpStyleEntry.style.alignItems;
        }

        if (includeAlignSelf) {
            styleEntry.style.alignSelf = tmpStyleEntry.style.alignSelf;
        }

        if (includeGap) {
            styleEntry.style.gap = tmpStyleEntry.style.gap;
        }

        if (includeBackgroundColor) {
            styleEntry.style.backgroundColor = tmpStyleEntry.style.backgroundColor;
        }

        if (includeWidth) {
            styleEntry.style.width = tmpStyleEntry.style.width;
        }

        if (includeHeight) {
            styleEntry.style.height = tmpStyleEntry.style.height;
        }

        if (includeMinWidth) {
            styleEntry.style.minWidth = tmpStyleEntry.style.minWidth;
        }

        if (includeMinHeight) {
            styleEntry.style.minHeight = tmpStyleEntry.style.minHeight;
        }

        if (includeMaxWidth) {
            styleEntry.style.maxWidth = tmpStyleEntry.style.maxWidth;
        }

        if (includeMaxHeight) {
            styleEntry.style.maxHeight = tmpStyleEntry.style.maxHeight;
        }

        if (includePadding) {
            styleEntry.style.padding = tmpStyleEntry.style.padding;
        }

        if (includePaddingHorizontal) {
            styleEntry.style.paddingHorizontal = tmpStyleEntry.style.paddingHorizontal;
        }

        if (includePaddingVertical) {
            styleEntry.style.paddingVertical = tmpStyleEntry.style.paddingVertical;
        }

        if (includePaddingTop) {
            styleEntry.style.paddingTop = tmpStyleEntry.style.paddingTop;
        }

        if (includePaddingLeft) {
            styleEntry.style.paddingLeft = tmpStyleEntry.style.paddingLeft;
        }

        if (includePaddingBottom) {
            styleEntry.style.paddingBottom = tmpStyleEntry.style.paddingBottom;
        }

        if (includePaddingRight) {
            styleEntry.style.paddingRight = tmpStyleEntry.style.paddingRight;
        }

        if (includeMargin) {
            styleEntry.style.margin = tmpStyleEntry.style.margin;
        }

        if (includeMarginHorizontal) {
            styleEntry.style.marginHorizontal = tmpStyleEntry.style.marginHorizontal;
        }

        if (includeMarginVertical) {
            styleEntry.style.marginVertical = tmpStyleEntry.style.marginVertical;
        }

        if (includeMarginTop) {
            styleEntry.style.marginTop = tmpStyleEntry.style.marginTop;
        }

        if (includeMarginLeft) {
            styleEntry.style.marginLeft = tmpStyleEntry.style.marginLeft;
        }

        if (includeMarginBottom) {
            styleEntry.style.marginBottom = tmpStyleEntry.style.marginBottom;
        }

        if (includeMarginRight) {
            styleEntry.style.marginRight = tmpStyleEntry.style.marginRight;
        }

        if (includeFontSize) {
            styleEntry.style.fontSize = tmpStyleEntry.style.fontSize;
        }

        if (includeLineHeight) {
            styleEntry.style.lineHeight = tmpStyleEntry.style.lineHeight;
        }

        if (includeFontWeight) {
            styleEntry.style.fontWeight = tmpStyleEntry.style.fontWeight;
        }

        if (includeColor) {
            styleEntry.style.color = tmpStyleEntry.style.color;
        }

        if (includeTextAlign) {
            styleEntry.style.textAlign = tmpStyleEntry.style.textAlign;
        }

        if (includeTextDecoration) {
            styleEntry.style.textDecoration = tmpStyleEntry.style.textDecoration;
        }

        if (includeTextTransform) {
            styleEntry.style.textTransform = tmpStyleEntry.style.textTransform;
        }

        if (includeTextOverflow) {
            styleEntry.style.textOverflow = tmpStyleEntry.style.textOverflow;
        }

        if (includeOverflowWrap) {
            styleEntry.style.overflowWrap = tmpStyleEntry.style.overflowWrap;
        }

        if (includeWordBreak) {
            styleEntry.style.wordBreak = tmpStyleEntry.style.wordBreak;
        }

        if (includePosition) {
            styleEntry.style.position = tmpStyleEntry.style.position;
        }

        if (includeTop) {
            styleEntry.style.top = tmpStyleEntry.style.top;
        }

        if (includeLeft) {
            styleEntry.style.left = tmpStyleEntry.style.left;
        }

        if (includeBottom) {
            styleEntry.style.bottom = tmpStyleEntry.style.bottom;
        }

        if (includeRight) {
            styleEntry.style.right = tmpStyleEntry.style.right;
        }

        if (includeZIndex) {
            styleEntry.style.zIndex = tmpStyleEntry.style.zIndex;
        }

        if (includeDisplay) {
            styleEntry.style.display = tmpStyleEntry.style.display;
        }

        if (includePointerEvents) {
            styleEntry.style.pointerEvents = tmpStyleEntry.style.pointerEvents;
        }

        if (includeObjectFit) {
            styleEntry.style.objectFit = tmpStyleEntry.style.objectFit;
        }

        if (includeOverflow) {
            styleEntry.style.overflow = tmpStyleEntry.style.overflow;
        }

        if (includeOpacity) {
            styleEntry.style.opacity = tmpStyleEntry.style.opacity;
        }

        if (includeAspectRatio) {
            styleEntry.style.aspectRatio = tmpStyleEntry.style.aspectRatio;
        }

        if (includeBorderRadius) {
            styleEntry.style.borderRadius = tmpStyleEntry.style.borderRadius;
        }

        if (includeBorderRadiusTopLeft) {
            styleEntry.style.borderRadiusTopLeft = tmpStyleEntry.style.borderRadiusTopLeft;
        }

        if (includeBorderRadiusTopRight) {
            styleEntry.style.borderRadiusTopRight = tmpStyleEntry.style.borderRadiusTopRight;
        }

        if (includeBorderRadiusBottomLeft) {
            styleEntry.style.borderRadiusBottomLeft = tmpStyleEntry.style.borderRadiusBottomLeft;
        }

        if (includeBorderRadiusBottomRight) {
            styleEntry.style.borderRadiusBottomRight = tmpStyleEntry.style.borderRadiusBottomRight;
        }

        if (includeBorderWidth) {
            styleEntry.style.borderWidth = tmpStyleEntry.style.borderWidth;
        }

        if (includeBorderColor) {
            styleEntry.style.borderColor = tmpStyleEntry.style.borderColor;
        }

        if (includeBorderTopWidth) {
            styleEntry.style.borderTopWidth = tmpStyleEntry.style.borderTopWidth;
        }

        if (includeBorderTopColor) {
            styleEntry.style.borderTopColor = tmpStyleEntry.style.borderTopColor;
        }

        if (includeBorderLeftWidth) {
            styleEntry.style.borderLeftWidth = tmpStyleEntry.style.borderLeftWidth;
        }

        if (includeBorderLeftColor) {
            styleEntry.style.borderLeftColor = tmpStyleEntry.style.borderLeftColor;
        }

        if (includeBorderBottomWidth) {
            styleEntry.style.borderBottomWidth = tmpStyleEntry.style.borderBottomWidth;
        }

        if (includeBorderBottomColor) {
            styleEntry.style.borderBottomColor = tmpStyleEntry.style.borderBottomColor;
        }

        if (includeBorderRightWidth) {
            styleEntry.style.borderRightWidth = tmpStyleEntry.style.borderRightWidth;
        }

        if (includeBorderRightColor) {
            styleEntry.style.borderRightColor = tmpStyleEntry.style.borderRightColor;
        }

        if (includeTransform) {
            styleEntry.style.transform = tmpStyleEntry.style.transform;
        }
    }

    public static void fillStyleEntry(StyleEntry styleEntry, List<StyleEntry> tmpStyleEntries) {
        for (StyleEntry tmpStyleEntry : tmpStyleEntries) {
            fillStyleEntry(styleEntry, tmpStyleEntry);
        }
    }

    public static void removeStyleEntryKeys(StyleEntry styleEntry, List<String> keys) {
        for (String key : keys) {
            if (!styleEntry.keys.contains(key)) {
                continue;
            }

            styleEntry.keys.remove(key);
        }

        boolean excludeFlex = keys.contains("flex");
        boolean excludeFlexDirection = keys.contains("flexDirection");
        boolean excludeJustifyContent = keys.contains("justifyContent");
        boolean excludeAlignItems = keys.contains("alignItems");
        boolean excludeAlignSelf = keys.contains("alignSelf");
        boolean excludeGap = keys.contains("gap");
        boolean excludeBackgroundColor = keys.contains("backgroundColor");
        boolean excludeWidth = keys.contains("width");
        boolean excludeHeight = keys.contains("height");
        boolean excludeMinWidth = keys.contains("minWidth");
        boolean excludeMinHeight = keys.contains("minHeight");
        boolean excludeMaxWidth = keys.contains("maxWidth");
        boolean excludeMaxHeight = keys.contains("maxHeight");
        boolean excludePadding = keys.contains("padding");
        boolean excludePaddingHorizontal = keys.contains("paddingHorizontal");
        boolean excludePaddingVertical = keys.contains("paddingVertical");
        boolean excludePaddingTop = keys.contains("paddingTop");
        boolean excludePaddingLeft = keys.contains("paddingLeft");
        boolean excludePaddingBottom = keys.contains("paddingBottom");
        boolean excludePaddingRight = keys.contains("paddingRight");
        boolean excludeMargin = keys.contains("margin");
        boolean excludeMarginHorizontal = keys.contains("marginHorizontal");
        boolean excludeMarginVertical = keys.contains("marginVertical");
        boolean excludeMarginTop = keys.contains("marginTop");
        boolean excludeMarginLeft = keys.contains("marginLeft");
        boolean excludeMarginBottom = keys.contains("marginBottom");
        boolean excludeMarginRight = keys.contains("marginRight");
        boolean excludeFontSize = keys.contains("fontSize");
        boolean excludeLineHeight = keys.contains("lineHeight");
        boolean excludeFontWeight = keys.contains("fontWeight");
        boolean excludeColor = keys.contains("color");
        boolean excludeTextAlign = keys.contains("textAlign");
        boolean excludeTextDecoration = keys.contains("textDecoration");
        boolean excludeTextTransform = keys.contains("textTransform");
        boolean excludeTextOverflow = keys.contains("textOverflow");
        boolean excludeOverflowWrap = keys.contains("overflowWrap");
        boolean excludeWordBreak = keys.contains("wordBreak");
        boolean excludePosition = keys.contains("position");
        boolean excludeTop = keys.contains("top");
        boolean excludeLeft = keys.contains("left");
        boolean excludeBottom = keys.contains("bottom");
        boolean excludeRight = keys.contains("right");
        boolean excludeZIndex = keys.contains("zIndex");
        boolean excludeDisplay = keys.contains("display");
        boolean excludePointerEvents = keys.contains("pointerEvents");
        boolean excludeObjectFit = keys.contains("objectFit");
        boolean excludeOverflow = keys.contains("overflow");
        boolean excludeOpacity = keys.contains("opacity");
        boolean excludeAspectRatio = keys.contains("aspectRatio");
        boolean excludeBorderRadius = keys.contains("borderRadius");
        boolean excludeBorderRadiusTopLeft = keys.contains("borderRadiusTopLeft");
        boolean excludeBorderRadiusTopRight = keys.contains("borderRadiusTopRight");
        boolean excludeBorderRadiusBottomLeft = keys.contains("borderRadiusBottomLeft");
        boolean excludeBorderRadiusBottomRight = keys.contains("borderRadiusBottomRight");
        boolean excludeBorderWidth = keys.contains("borderWidth");
        boolean excludeBorderColor = keys.contains("borderColor");
        boolean excludeBorderTopWidth = keys.contains("borderTopWidth");
        boolean excludeBorderTopColor = keys.contains("borderTopColor");
        boolean excludeBorderLeftWidth = keys.contains("borderLeftWidth");
        boolean excludeBorderLeftColor = keys.contains("borderLeftColor");
        boolean excludeBorderBottomWidth = keys.contains("borderBottomWidth");
        boolean excludeBorderBottomColor = keys.contains("borderBottomColor");
        boolean excludeBorderRightWidth = keys.contains("borderRightWidth");
        boolean excludeBorderRightColor = keys.contains("borderRightColor");
        boolean excludeTransform = keys.contains("transform");

        if (excludeFlex) {
            styleEntry.style.flex = null;
        }

        if (excludeFlexDirection) {
            styleEntry.style.flexDirection = null;
        }

        if (excludeJustifyContent) {
            styleEntry.style.justifyContent = null;
        }

        if (excludeAlignItems) {
            styleEntry.style.alignItems = null;
        }

        if (excludeAlignSelf) {
            styleEntry.style.alignSelf = null;
        }

        if (excludeGap) {
            styleEntry.style.gap = null;
        }

        if (excludeBackgroundColor) {
            styleEntry.style.backgroundColor = null;
        }

        if (excludeWidth) {
            styleEntry.style.width = null;
        }

        if (excludeHeight) {
            styleEntry.style.height = null;
        }

        if (excludeMinWidth) {
            styleEntry.style.minWidth = null;
        }

        if (excludeMinHeight) {
            styleEntry.style.minHeight = null;
        }

        if (excludeMaxWidth) {
            styleEntry.style.maxWidth = null;
        }

        if (excludeMaxHeight) {
            styleEntry.style.maxHeight = null;
        }

        if (excludePadding) {
            styleEntry.style.padding = null;
        }

        if (excludePaddingHorizontal) {
            styleEntry.style.paddingHorizontal = null;
        }

        if (excludePaddingVertical) {
            styleEntry.style.paddingVertical = null;
        }

        if (excludePaddingTop) {
            styleEntry.style.paddingTop = null;
        }

        if (excludePaddingLeft) {
            styleEntry.style.paddingLeft = null;
        }

        if (excludePaddingBottom) {
            styleEntry.style.paddingBottom = null;
        }

        if (excludePaddingRight) {
            styleEntry.style.paddingRight = null;
        }

        if (excludeMargin) {
            styleEntry.style.margin = null;
        }

        if (excludeMarginHorizontal) {
            styleEntry.style.marginHorizontal = null;
        }

        if (excludeMarginVertical) {
            styleEntry.style.marginVertical = null;
        }

        if (excludeMarginTop) {
            styleEntry.style.marginTop = null;
        }

        if (excludeMarginLeft) {
            styleEntry.style.marginLeft = null;
        }

        if (excludeMarginBottom) {
            styleEntry.style.marginBottom = null;
        }

        if (excludeMarginRight) {
            styleEntry.style.marginRight = null;
        }

        if (excludeFontSize) {
            styleEntry.style.fontSize = null;
        }

        if (excludeLineHeight) {
            styleEntry.style.lineHeight = null;
        }

        if (excludeFontWeight) {
            styleEntry.style.fontWeight = null;
        }

        if (excludeColor) {
            styleEntry.style.color = null;
        }

        if (excludeTextAlign) {
            styleEntry.style.textAlign = null;
        }

        if (excludeTextDecoration) {
            styleEntry.style.textDecoration = null;
        }

        if (excludeTextTransform) {
            styleEntry.style.textTransform = null;
        }

        if (excludeTextOverflow) {
            styleEntry.style.textOverflow = null;
        }

        if (excludeOverflowWrap) {
            styleEntry.style.overflowWrap = null;
        }

        if (excludeWordBreak) {
            styleEntry.style.wordBreak = null;
        }

        if (excludePosition) {
            styleEntry.style.position = null;
        }

        if (excludeTop) {
            styleEntry.style.top = null;
        }

        if (excludeLeft) {
            styleEntry.style.left = null;
        }

        if (excludeBottom) {
            styleEntry.style.bottom = null;
        }

        if (excludeRight) {
            styleEntry.style.right = null;
        }

        if (excludeZIndex) {
            styleEntry.style.zIndex = null;
        }

        if (excludeDisplay) {
            styleEntry.style.display = null;
        }

        if (excludePointerEvents) {
            styleEntry.style.pointerEvents = null;
        }

        if (excludeObjectFit) {
            styleEntry.style.objectFit = null;
        }

        if (excludeOverflow) {
            styleEntry.style.overflow = null;
        }

        if (excludeOpacity) {
            styleEntry.style.opacity = null;
        }

        if (excludeAspectRatio) {
            styleEntry.style.aspectRatio = null;
        }

        if (excludeBorderRadius) {
            styleEntry.style.borderRadius = null;
        }

        if (excludeBorderRadiusTopLeft) {
            styleEntry.style.borderRadiusTopLeft = null;
        }

        if (excludeBorderRadiusTopRight) {
            styleEntry.style.borderRadiusTopRight = null;
        }

        if (excludeBorderRadiusBottomLeft) {
            styleEntry.style.borderRadiusBottomLeft = null;
        }

        if (excludeBorderRadiusBottomRight) {
            styleEntry.style.borderRadiusBottomRight = null;
        }

        if (excludeBorderWidth) {
            styleEntry.style.borderWidth = null;
        }

        if (excludeBorderColor) {
            styleEntry.style.borderColor = null;
        }

        if (excludeBorderTopWidth) {
            styleEntry.style.borderTopWidth = null;
        }

        if (excludeBorderTopColor) {
            styleEntry.style.borderTopColor = null;
        }

        if (excludeBorderLeftWidth) {
            styleEntry.style.borderLeftWidth = null;
        }

        if (excludeBorderLeftColor) {
            styleEntry.style.borderLeftColor = null;
        }

        if (excludeBorderBottomWidth) {
            styleEntry.style.borderBottomWidth = null;
        }

        if (excludeBorderBottomColor) {
            styleEntry.style.borderBottomColor = null;
        }

        if (excludeBorderRightWidth) {
            styleEntry.style.borderRightWidth = null;
        }

        if (excludeBorderRightColor) {
            styleEntry.style.borderRightColor = null;
        }

        if (excludeTransform) {
            styleEntry.style.transform = null;
        }
    }
}
