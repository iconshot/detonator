package com.iconshot.detonator.element;

import java.util.List;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.RoundRectShape;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ColorHelper;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.AttributeHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.PixelHelper;
import com.iconshot.detonator.layout.ViewLayout.LayoutParams;
import com.iconshot.detonator.tree.Edge;
import com.iconshot.detonator.element.Style.StyleTransform;

public abstract class Element<K extends View, T extends Element.Attributes> {
    protected Detonator detonator;

    public Edge edge;
    public Edge currentEdge;

    public K view;

    protected T attributes;
    protected T currentAttributes;

    protected Styler styler;
    protected Styler currentStyler;

    protected boolean forcePatch = true;

    public Element(Detonator detonator) {
        this.detonator = detonator;
    }

    protected abstract Class<T> getAttributesClass();

    protected T decodeAttributes(Edge edge) {
        Class<T> AttributesClass = getAttributesClass();

        return detonator.gson.fromJson(edge.attributes, AttributesClass);
    }

    public void create() {
        view = createView();

        LayoutParams layoutParams = new LayoutParams(
                LayoutParams.WRAP_CONTENT,
                LayoutParams.WRAP_CONTENT
        );

        view.setLayoutParams(layoutParams);

        view.setOnClickListener((View v) -> {
            detonator.emitHandler("onTap", edge.id);
        });
    }

    public void patch() {
        attributes = decodeAttributes(edge);
        currentAttributes = currentEdge != null ? decodeAttributes(currentEdge) : null;

        forcePatch = currentAttributes == null;

        Style style = attributes.style;
        Style currentStyle = currentAttributes != null ? currentAttributes.style: null;

        styler = new Styler(style);
        currentStyler = new Styler(currentStyle);

        Integer flex = styler.getFlex();
        String flexDirection = styler.getFlexDirection();
        String justifyContent = styler.getJustifyContent();
        String alignItems = styler.getAlignItems();
        String alignSelf = styler.getAlignSelf();
        Object backgroundColor = styler.getBackgroundColor();
        Object width = styler.getWidth();
        Object height = styler.getHeight();
        Object minWidth = styler.getMinWidth();
        Object minHeight = styler.getMinHeight();
        Object maxWidth = styler.getMaxWidth();
        Object maxHeight = styler.getMaxHeight();
        Float padding = styler.getPadding();
        Float paddingHorizontal = styler.getPaddingHorizontal();
        Float paddingVertical = styler.getPaddingVertical();
        Float paddingTop = styler.getPaddingTop();
        Float paddingLeft = styler.getPaddingLeft();
        Float paddingBottom = styler.getPaddingBottom();
        Float paddingRight = styler.getPaddingRight();
        Float margin = styler.getMargin();
        Float marginHorizontal = styler.getMarginHorizontal();
        Float marginVertical = styler.getMarginVertical();
        Float marginTop = styler.getMarginTop();
        Float marginLeft = styler.getMarginLeft();
        Float marginBottom = styler.getMarginBottom();
        Float marginRight = styler.getMarginRight();
        Float fontSize = styler.getFontSize();
        Float lineHeight = styler.getLineHeight();
        String fontWeight = styler.getFontWeight();
        Object color = styler.getColor();
        String textAlign = styler.getTextAlign();
        String textDecoration = styler.getTextDecoration();
        String textTransform = styler.getTextTransform();
        String textOverflow = styler.getTextOverflow();
        String overflowWrap = styler.getOverflowWrap();
        String wordBreak = styler.getWordBreak();
        String position = styler.getPosition();
        Float top = styler.getTop();
        Float left = styler.getLeft();
        Float bottom = styler.getBottom();
        Float right = styler.getRight();
        Integer zIndex = styler.getZIndex();
        String display = styler.getDisplay();
        String pointerEvents = styler.getPointerEvents();
        String objectFit = styler.getObjectFit();
        String overflow = styler.getOverflow();
        Float opacity = styler.getOpacity();
        Float aspectRatio = styler.getAspectRatio();
        Object borderRadius = styler.getBorderRadius();
        Object borderRadiusTopLeft = styler.getBorderRadiusTopLeft();
        Object borderRadiusTopRight = styler.getBorderRadiusTopRight();
        Object borderRadiusBottomLeft = styler.getBorderRadiusBottomLeft();
        Object borderRadiusBottomRight = styler.getBorderRadiusBottomRight();
        Float borderWidth = styler.getBorderWidth();
        Object borderColor = styler.getBorderColor();
        Float borderTopWidth = styler.getBorderTopWidth();
        Object borderTopColor = styler.getBorderTopColor();
        Float borderLeftWidth = styler.getBorderLeftWidth();
        Object borderLeftColor = styler.getBorderLeftColor();
        Float borderBottomWidth = styler.getBorderBottomWidth();
        Object borderBottomColor = styler.getBorderBottomColor();
        Float borderRightWidth = styler.getBorderRightWidth();
        Object borderRightColor = styler.getBorderRightColor();
        StyleTransform transform = styler.getTransform();

        Integer currentFlex = currentStyler.getFlex();
        String currentFlexDirection = currentStyler.getFlexDirection();
        String currentJustifyContent = currentStyler.getJustifyContent();
        String currentAlignItems = currentStyler.getAlignItems();
        String currentAlignSelf = currentStyler.getAlignSelf();
        Object currentBackgroundColor = currentStyler.getBackgroundColor();
        Object currentWidth = currentStyler.getWidth();
        Object currentHeight = currentStyler.getHeight();
        Object currentMinWidth = currentStyler.getMinWidth();
        Object currentMinHeight = currentStyler.getMinHeight();
        Object currentMaxWidth = currentStyler.getMaxWidth();
        Object currentMaxHeight = currentStyler.getMaxHeight();
        Float currentPadding = currentStyler.getPadding();
        Float currentPaddingHorizontal = currentStyler.getPaddingHorizontal();
        Float currentPaddingVertical = currentStyler.getPaddingVertical();
        Float currentPaddingTop = currentStyler.getPaddingTop();
        Float currentPaddingLeft = currentStyler.getPaddingLeft();
        Float currentPaddingBottom = currentStyler.getPaddingBottom();
        Float currentPaddingRight = currentStyler.getPaddingRight();
        Float currentMargin = currentStyler.getMargin();
        Float currentMarginHorizontal = currentStyler.getMarginHorizontal();
        Float currentMarginVertical = currentStyler.getMarginVertical();
        Float currentMarginTop = currentStyler.getMarginTop();
        Float currentMarginLeft = currentStyler.getMarginLeft();
        Float currentMarginBottom = currentStyler.getMarginBottom();
        Float currentMarginRight = currentStyler.getMarginRight();
        Float currentFontSize = currentStyler.getFontSize();
        Float currentLineHeight = currentStyler.getLineHeight();
        String currentFontWeight = currentStyler.getFontWeight();
        Object currentColor = currentStyler.getColor();
        String currentTextAlign = currentStyler.getTextAlign();
        String currentTextDecoration = currentStyler.getTextDecoration();
        String currentTextTransform = currentStyler.getTextTransform();
        String currentTextOverflow = currentStyler.getTextOverflow();
        String currentOverflowWrap = currentStyler.getOverflowWrap();
        String currentWordBreak = currentStyler.getWordBreak();
        String currentPosition = currentStyler.getPosition();
        Float currentTop = currentStyler.getTop();
        Float currentLeft = currentStyler.getLeft();
        Float currentBottom = currentStyler.getBottom();
        Float currentRight = currentStyler.getRight();
        Integer currentZIndex = currentStyler.getZIndex();
        String currentDisplay = currentStyler.getDisplay();
        String currentPointerEvents = currentStyler.getPointerEvents();
        String currentObjectFit = currentStyler.getObjectFit();
        String currentOverflow = currentStyler.getOverflow();
        Float currentOpacity = currentStyler.getOpacity();
        Float currentAspectRatio = currentStyler.getAspectRatio();
        Object currentBorderRadius = currentStyler.getBorderRadius();
        Object currentBorderRadiusTopLeft = currentStyler.getBorderRadiusTopLeft();
        Object currentBorderRadiusTopRight = currentStyler.getBorderRadiusTopRight();
        Object currentBorderRadiusBottomLeft = currentStyler.getBorderRadiusBottomLeft();
        Object currentBorderRadiusBottomRight = currentStyler.getBorderRadiusBottomRight();
        Float currentBorderWidth = currentStyler.getBorderWidth();
        Object currentBorderColor = currentStyler.getBorderColor();
        Float currentBorderTopWidth = currentStyler.getBorderTopWidth();
        Object currentBorderTopColor = currentStyler.getBorderTopColor();
        Float currentBorderLeftWidth = currentStyler.getBorderLeftWidth();
        Object currentBorderLeftColor = currentStyler.getBorderLeftColor();
        Float currentBorderBottomWidth = currentStyler.getBorderBottomWidth();
        Object currentBorderBottomColor = currentStyler.getBorderBottomColor();
        Float currentBorderRightWidth = currentStyler.getBorderRightWidth();
        Object currentBorderRightColor = currentStyler.getBorderRightColor();
        StyleTransform currentTransform = currentStyler.getTransform();

        boolean patchFlex = forcePatch || !CompareHelper.compareObjects(flex, currentFlex);
        boolean patchFlexDirection = forcePatch || !CompareHelper.compareObjects(flexDirection, currentFlexDirection);
        boolean patchJustifyContent = forcePatch || !CompareHelper.compareObjects(justifyContent, currentJustifyContent);
        boolean patchAlignItems = forcePatch || !CompareHelper.compareObjects(alignItems, currentAlignItems);
        boolean patchAlignSelf = forcePatch || !CompareHelper.compareObjects(alignSelf, currentAlignSelf);
        boolean patchBackgroundColor = forcePatch || !CompareHelper.compareColors(backgroundColor, currentBackgroundColor);
        boolean patchWidth = forcePatch || !CompareHelper.compareObjects(width, currentWidth);
        boolean patchHeight = forcePatch || !CompareHelper.compareObjects(height, currentHeight);
        boolean patchMinWidth = forcePatch || !CompareHelper.compareObjects(minWidth, currentMinWidth);
        boolean patchMinHeight = forcePatch || !CompareHelper.compareObjects(minHeight, currentMinHeight);
        boolean patchMaxWidth = forcePatch || !CompareHelper.compareObjects(maxWidth, currentMaxWidth);
        boolean patchMaxHeight = forcePatch || !CompareHelper.compareObjects(maxHeight, currentMaxHeight);
        boolean patchPadding = forcePatch || !CompareHelper.compareObjects(padding, currentPadding);
        boolean patchPaddingHorizontal = forcePatch || !CompareHelper.compareObjects(paddingHorizontal, currentPaddingHorizontal);
        boolean patchPaddingVertical = forcePatch || !CompareHelper.compareObjects(paddingVertical, currentPaddingVertical);
        boolean patchPaddingTop = forcePatch || !CompareHelper.compareObjects(paddingTop, currentPaddingTop);
        boolean patchPaddingLeft = forcePatch || !CompareHelper.compareObjects(paddingLeft, currentPaddingLeft);
        boolean patchPaddingBottom = forcePatch || !CompareHelper.compareObjects(paddingBottom, currentPaddingBottom);
        boolean patchPaddingRight = forcePatch || !CompareHelper.compareObjects(paddingRight, currentPaddingRight);
        boolean patchMargin = forcePatch || !CompareHelper.compareObjects(margin, currentMargin);
        boolean patchMarginHorizontal = forcePatch || !CompareHelper.compareObjects(marginHorizontal, currentMarginHorizontal);
        boolean patchMarginVertical = forcePatch || !CompareHelper.compareObjects(marginVertical, currentMarginVertical);
        boolean patchMarginTop = forcePatch || !CompareHelper.compareObjects(marginTop, currentMarginTop);
        boolean patchMarginLeft = forcePatch || !CompareHelper.compareObjects(marginLeft, currentMarginLeft);
        boolean patchMarginBottom = forcePatch || !CompareHelper.compareObjects(marginBottom, currentMarginBottom);
        boolean patchMarginRight = forcePatch || !CompareHelper.compareObjects(marginRight, currentMarginRight);
        boolean patchFontSize = forcePatch || !CompareHelper.compareObjects(fontSize, currentFontSize);
        boolean patchLineHeight = forcePatch || !CompareHelper.compareObjects(lineHeight, currentLineHeight);
        boolean patchFontWeight = forcePatch || !CompareHelper.compareObjects(fontWeight, currentFontWeight);
        boolean patchColor = forcePatch || !CompareHelper.compareColors(color, currentColor);
        boolean patchTextAlign = forcePatch || !CompareHelper.compareObjects(textAlign, currentTextAlign);
        boolean patchTextDecoration = forcePatch || !CompareHelper.compareObjects(textDecoration, currentTextDecoration);
        boolean patchTextTransform = forcePatch || !CompareHelper.compareObjects(textTransform, currentTextTransform);
        boolean patchTextOverflow = forcePatch || !CompareHelper.compareObjects(textOverflow, currentTextOverflow);
        boolean patchOverflowWrap = forcePatch || !CompareHelper.compareObjects(overflowWrap, currentOverflowWrap);
        boolean patchWordBreak = forcePatch || !CompareHelper.compareObjects(wordBreak, currentWordBreak);
        boolean patchPosition = forcePatch || !CompareHelper.compareObjects(position, currentPosition);
        boolean patchTop = forcePatch || !CompareHelper.compareObjects(top, currentTop);
        boolean patchLeft = forcePatch || !CompareHelper.compareObjects(left, currentLeft);
        boolean patchBottom = forcePatch || !CompareHelper.compareObjects(bottom, currentBottom);
        boolean patchRight = forcePatch || !CompareHelper.compareObjects(right, currentRight);
        boolean patchZIndex = forcePatch || !CompareHelper.compareObjects(zIndex, currentZIndex);
        boolean patchDisplay = forcePatch || !CompareHelper.compareObjects(display, currentDisplay);
        boolean patchPointerEvents = forcePatch || !CompareHelper.compareObjects(pointerEvents, currentPointerEvents);
        boolean patchObjectFit = forcePatch || !CompareHelper.compareObjects(objectFit, currentObjectFit);
        boolean patchOverflow = forcePatch || !CompareHelper.compareObjects(overflow, currentOverflow);
        boolean patchOpacity = forcePatch || !CompareHelper.compareObjects(opacity, currentOpacity);
        boolean patchAspectRatio = forcePatch || !CompareHelper.compareObjects(aspectRatio, currentAspectRatio);
        boolean patchBorderRadius = forcePatch || !CompareHelper.compareObjects(borderRadius, currentBorderRadius);
        boolean patchBorderRadiusTopLeft = forcePatch || !CompareHelper.compareObjects(borderRadiusTopLeft, currentBorderRadiusTopLeft);
        boolean patchBorderRadiusTopRight = forcePatch || !CompareHelper.compareObjects(borderRadiusTopRight, currentBorderRadiusTopRight);
        boolean patchBorderRadiusBottomLeft = forcePatch || !CompareHelper.compareObjects(borderRadiusBottomLeft, currentBorderRadiusBottomLeft);
        boolean patchBorderRadiusBottomRight = forcePatch || !CompareHelper.compareObjects(borderRadiusBottomRight, currentBorderRadiusBottomRight);
        boolean patchTransform = forcePatch || !CompareHelper.compareTransform(transform, currentTransform);

        if (patchFlex) {
            patchFlex(flex);
        }

        if (patchFlexDirection) {
            patchFlexDirection(flexDirection);
        }

        if (patchJustifyContent) {
            patchJustifyContent(justifyContent);
        }

        if (patchAlignItems) {
            patchAlignItems(alignItems);
        }

        if (patchAlignSelf) {
            patchAlignSelf(alignSelf);
        }

        if (
                patchBackgroundColor
                        || patchBorderRadius
                        || patchBorderRadiusTopLeft
                        || patchBorderRadiusTopRight
                        || patchBorderRadiusBottomLeft
                        || patchBorderRadiusBottomRight
        ) {
            patchBackgroundColor(
                    backgroundColor,
                    borderRadius,
                    borderRadiusTopLeft,
                    borderRadiusTopRight,
                    borderRadiusBottomLeft,
                    borderRadiusBottomRight
            );
        }

        if (patchWidth) {
            patchWidth(width);
        }

        if (patchHeight) {
            patchHeight(height);
        }

        if (patchMinWidth) {
            patchMinWidth(minWidth);
        }

        if (patchMinHeight) {
            patchMinHeight(minHeight);
        }

        if (patchMaxWidth) {
            patchMaxWidth(maxWidth);
        }

        if (patchMaxHeight) {
            patchMaxHeight(maxHeight);
        }

        if (
                patchPadding
                        || patchPaddingHorizontal
                        || patchPaddingVertical
                        || patchPaddingTop
                        || patchPaddingLeft
                        || patchPaddingBottom
                        || patchPaddingRight
        ) {
            patchPadding(
                    padding,
                    paddingHorizontal,
                    paddingVertical,
                    paddingTop,
                    paddingLeft,
                    paddingBottom,
                    paddingRight
            );
        }

        if (
                patchMargin
                        || patchMarginHorizontal
                        || patchMarginVertical
                        || patchMarginTop
                        || patchMarginLeft
                        || patchMarginBottom
                        || patchMarginRight
        ) {
            patchMargin(
                    margin,
                    marginHorizontal,
                    marginVertical,
                    marginTop,
                    marginLeft,
                    marginBottom,
                    marginRight
            );
        }

        if (patchFontSize) {
            patchFontSize(fontSize);
        }

        if (patchLineHeight) {
            patchLineHeight(lineHeight);
        }

        if (patchFontWeight) {
            patchFontWeight(fontWeight);
        }

        if (patchColor) {
            patchColor(color);
        }

        if (patchTextAlign) {
            patchTextAlign(textAlign);
        }

        if (patchTextDecoration) {
            patchTextDecoration(textDecoration);
        }

        if (patchTextTransform) {
            patchTextTransform(textTransform);
        }

        if (patchTextOverflow) {
            patchTextOverflow(textOverflow);
        }

        if (patchOverflowWrap) {
            patchOverflowWrap(overflowWrap);
        }

        if (patchWordBreak) {
            patchWordBreak(wordBreak);
        }

        if (patchPosition) {
            patchPosition(position);
        }

        if (patchTop) {
            patchTop(top);
        }

        if (patchLeft) {
            patchLeft(left);
        }

        if (patchBottom) {
            patchBottom(bottom);
        }

        if (patchRight) {
            patchRight(right);
        }

        if (patchZIndex) {
            patchZIndex(zIndex);
        }

        if (patchDisplay) {
            patchDisplay(display);
        }

        if (patchPointerEvents) {
            patchPointerEvents(pointerEvents);
        }

        if (patchObjectFit) {
            patchObjectFit(objectFit);
        }

        if (patchOverflow) {
            patchOverflow(overflow);
        }

        if (patchOpacity) {
            patchOpacity(opacity);
        }

        if (patchAspectRatio) {
            patchAspectRatio(aspectRatio);
        }

        if (patchTransform) {
            patchTransform(transform);
        }

        patchView();
    }

    protected void patchFlex(Integer flex) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.flex = flex;
    }

    protected void patchFlexDirection(String flexDirection) {
    }

    protected void patchJustifyContent(String justifyContent) {
    }

    protected void patchAlignItems(String alignItems) {
    }

    protected void patchAlignSelf(String alignSelf) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        Integer tmpAlignSelf = null;

        if (alignSelf != null) {
            switch (alignSelf) {
                case "flex-start": {
                    tmpAlignSelf = LayoutParams.ALIGN_ITEMS_FLEX_START;

                    break;
                }

                case "flex-end": {
                    tmpAlignSelf = LayoutParams.ALIGN_ITEMS_FLEX_END;

                    break;
                }

                case "start": {
                    tmpAlignSelf = LayoutParams.ALIGN_ITEMS_START;

                    break;
                }

                case "end": {
                    tmpAlignSelf = LayoutParams.ALIGN_ITEMS_END;

                    break;
                }

                case "center": {
                    tmpAlignSelf = LayoutParams.ALIGN_ITEMS_CENTER;

                    break;
                }
            }
        }

        layoutParams.alignSelf = tmpAlignSelf;
    }

    protected void patchBackgroundColor(
            Object backgroundColor,
            Object borderRadius,
            Object borderRadiusTopLeft,
            Object borderRadiusTopRight,
            Object borderRadiusBottomLeft,
            Object borderRadiusBottomRight
    ) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.onLayoutClosures.put("backgroundColor", () -> {
            float[] radii = getRadii(
                    borderRadius,
                    borderRadiusTopLeft,
                    borderRadiusTopRight,
                    borderRadiusBottomLeft,
                    borderRadiusBottomRight
            );

            RoundRectShape roundRectShape = new RoundRectShape(radii, null, null);

            ShapeDrawable shapeDrawable = new ShapeDrawable(roundRectShape);

            Integer tmpBackgroundColor = backgroundColor != null ? ColorHelper.parseColor(backgroundColor) : null;

            int paintColor = tmpBackgroundColor != null ? tmpBackgroundColor : Color.TRANSPARENT;

            shapeDrawable.getPaint().setColor(paintColor);

            view.setBackground(shapeDrawable);
        });
    }

    protected float[] getRadii(
            Object borderRadius,
            Object borderRadiusTopLeft,
            Object borderRadiusTopRight,
            Object borderRadiusBottomLeft,
            Object borderRadiusBottomRight
    ) {
        int width = view.getWidth();
        int height = view.getHeight();

        float tmpBorderRadius = convertBorderRadius(borderRadius, width, height);

        float tmpBorderRadiusTopLeft = borderRadiusTopLeft != null
                ? convertBorderRadius(borderRadiusTopLeft, width, height)
                : tmpBorderRadius;

        float tmpBorderRadiusTopRight = borderRadiusTopRight != null
                ? convertBorderRadius(borderRadiusTopRight, width, height)
                : tmpBorderRadius;

        float tmpBorderRadiusBottomLeft = borderRadiusBottomLeft != null
                ? convertBorderRadius(borderRadiusBottomLeft, width, height)
                : tmpBorderRadius;

        float tmpBorderRadiusBottomRight = borderRadiusBottomRight != null
                ? convertBorderRadius(borderRadiusBottomRight, width, height)
                : tmpBorderRadius;

        return new float[] {
                tmpBorderRadiusTopLeft,
                tmpBorderRadiusTopLeft,
                tmpBorderRadiusTopRight,
                tmpBorderRadiusTopRight,
                tmpBorderRadiusBottomRight,
                tmpBorderRadiusBottomRight,
                tmpBorderRadiusBottomLeft,
                tmpBorderRadiusBottomLeft,
        };
    }

    private float convertBorderRadius(Object size, int width, int height) {
        int minSize = Math.min(width, height);

        float maxRadius = (float) minSize / 2;

        float value = 0;

        if (size instanceof Double) {
            value = PixelHelper.dpToPx((double) size);
        } else if (size instanceof String) {
            value = minSize * AttributeHelper.convertPercentStringToFloat((String) size);
        }

        return Math.min(value, maxRadius);
    }

    protected void patchWidth(Object width) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        if (width != null) {
            if (width instanceof Double) {
                layoutParams.width = PixelHelper.dpToPx((double) width);

                layoutParams.widthPercent = null;
            } else {
                layoutParams.width = LayoutParams.WRAP_CONTENT;

                layoutParams.widthPercent = AttributeHelper.convertPercentStringToFloat((String) width);
            }
        } else {
            layoutParams.width = LayoutParams.WRAP_CONTENT;

            layoutParams.widthPercent = null;
        }
    }

    protected void patchHeight(Object height) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        if (height != null) {
            if (height instanceof Double) {
                layoutParams.height = PixelHelper.dpToPx((double) height);

                layoutParams.heightPercent = null;
            } else {
                layoutParams.height = LayoutParams.WRAP_CONTENT;

                layoutParams.heightPercent = AttributeHelper.convertPercentStringToFloat((String) height);
            }
        } else {
            layoutParams.height = LayoutParams.WRAP_CONTENT;

            layoutParams.heightPercent = null;
        }
    }

    protected void patchMinWidth(Object minWidth) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        if (minWidth != null) {
            if (minWidth instanceof Double) {
                layoutParams.minWidth = PixelHelper.dpToPx((double) minWidth);

                layoutParams.minWidthPercent = null;
            } else {
                layoutParams.minWidth = null;

                layoutParams.minWidthPercent = AttributeHelper.convertPercentStringToFloat((String) minWidth);
            }
        } else {
            layoutParams.minWidth = null;

            layoutParams.minWidthPercent = null;
        }
    }

    protected void patchMinHeight(Object minHeight) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        if (minHeight != null) {
            if (minHeight instanceof Double) {
                layoutParams.minHeight = PixelHelper.dpToPx((double) minHeight);

                layoutParams.minHeightPercent = null;
            } else {
                layoutParams.minHeight = null;

                layoutParams.minHeightPercent = AttributeHelper.convertPercentStringToFloat((String) minHeight);
            }
        } else {
            layoutParams.minHeight = null;

            layoutParams.minHeightPercent = null;
        }
    }

    protected void patchMaxWidth(Object maxWidth) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        if (maxWidth != null) {
            if (maxWidth instanceof Double) {
                layoutParams.maxWidth = PixelHelper.dpToPx((double) maxWidth);

                layoutParams.maxWidthPercent = null;
            } else {
                layoutParams.maxWidth = null;

                layoutParams.maxWidthPercent = AttributeHelper.convertPercentStringToFloat((String) maxWidth);
            }
        } else {
            layoutParams.maxWidth = null;

            layoutParams.maxWidthPercent = null;
        }
    }

    protected void patchMaxHeight(Object maxHeight) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        if (maxHeight != null) {
            if (maxHeight instanceof Double) {
                layoutParams.maxHeight = PixelHelper.dpToPx((double) maxHeight);

                layoutParams.maxHeightPercent = null;
            } else {
                layoutParams.maxHeight = null;

                layoutParams.maxHeightPercent = AttributeHelper.convertPercentStringToFloat((String) maxHeight);
            }
        } else {
            layoutParams.maxHeight = null;

            layoutParams.maxHeightPercent = null;
        }
    }

    protected void patchPadding(
            Float padding,
            Float paddingHorizontal,
            Float paddingVertical,
            Float paddingTop,
            Float paddingLeft,
            Float paddingBottom,
            Float paddingRight
    ) {
        int tmpPadding = padding != null ? PixelHelper.dpToPx(padding) : 0;

        int tmpPaddingTop = tmpPadding;
        int tmpPaddingLeft = tmpPadding;
        int tmpPaddingBottom = tmpPadding;
        int tmpPaddingRight = tmpPadding;

        if (paddingHorizontal != null) {
            int tmpPaddingHorizontal = PixelHelper.dpToPx(paddingHorizontal);

            tmpPaddingLeft = tmpPaddingHorizontal;
            tmpPaddingRight = tmpPaddingHorizontal;
        }

        if (paddingVertical != null) {
            int tmpPaddingVertical = PixelHelper.dpToPx(paddingVertical);

            tmpPaddingTop = tmpPaddingVertical;
            tmpPaddingBottom = tmpPaddingVertical;
        }

        if (paddingTop != null) {
            tmpPaddingTop = PixelHelper.dpToPx(paddingTop);
        }

        if (paddingLeft != null) {
            tmpPaddingLeft = PixelHelper.dpToPx(paddingLeft);
        }

        if (paddingBottom != null) {
            tmpPaddingBottom = PixelHelper.dpToPx(paddingBottom);
        }

        if (paddingRight != null) {
            tmpPaddingRight = PixelHelper.dpToPx(paddingRight);
        }

        view.setPadding(tmpPaddingLeft, tmpPaddingTop, tmpPaddingRight, tmpPaddingBottom);
    }

    protected void patchMargin(
            Float margin,
            Float marginHorizontal,
            Float marginVertical,
            Float marginTop,
            Float marginLeft,
            Float marginBottom,
            Float marginRight
    ) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        int tmpMargin = margin != null ? PixelHelper.dpToPx(margin) : 0;

        int tmpMarginTop = tmpMargin;
        int tmpMarginLeft = tmpMargin;
        int tmpMarginBottom = tmpMargin;
        int tmpMarginRight = tmpMargin;

        if (marginHorizontal != null) {
            int tmpMarginHorizontal = PixelHelper.dpToPx(marginHorizontal);

            tmpMarginLeft = tmpMarginHorizontal;
            tmpMarginRight = tmpMarginHorizontal;
        }

        if (marginVertical != null) {
            int tmpMarginVertical = PixelHelper.dpToPx(marginVertical);

            tmpMarginTop = tmpMarginVertical;
            tmpMarginBottom = tmpMarginVertical;
        }

        if (marginTop != null) {
            tmpMarginTop = PixelHelper.dpToPx(marginTop);
        }

        if (marginLeft != null) {
            tmpMarginLeft = PixelHelper.dpToPx(marginLeft);
        }

        if (marginBottom != null) {
            tmpMarginBottom = PixelHelper.dpToPx(marginBottom);
        }

        if (marginRight != null) {
            tmpMarginRight = PixelHelper.dpToPx(marginRight);
        }

        layoutParams.setMargins(tmpMarginLeft, tmpMarginTop, tmpMarginRight, tmpMarginBottom);
    }

    protected void patchFontSize(Float fontSize) {
    }

    protected void patchLineHeight(Float lineHeight) {
    }

    protected void patchFontWeight(String fontWeight) {
    }

    protected void patchColor(Object color) {
    }

    protected void patchTextAlign(String textAlign) {
    }

    protected void patchTextDecoration(String textDecoration) {
    }

    protected void patchTextTransform(String textTransform) {
    }

    protected void patchTextOverflow(String textOverflow) {
    }

    protected void patchOverflowWrap(String overflowWrap) {
    }

    protected void patchWordBreak(String wordBreak) {
    }

    protected void patchPosition(String position) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        int tmpPosition = LayoutParams.POSITION_RELATIVE;

        if (position != null) {
            switch (position) {
                case "absolute": {
                    tmpPosition = LayoutParams.POSITION_ABSOLUTE;

                    break;
                }
            }
        }

        layoutParams.position = tmpPosition;
    }

    protected void patchTop(Float top) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.positionTop = top != null ? PixelHelper.dpToPx(top) : null;
    }

    protected void patchLeft(Float left) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.positionLeft = left != null ? PixelHelper.dpToPx(left) : null;
    }

    protected void patchBottom(Float bottom) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.positionBottom = bottom != null ? PixelHelper.dpToPx(bottom) : null;
    }

    protected void patchRight(Float right) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.positionRight = right != null ? PixelHelper.dpToPx(right) : null;
    }

    protected void patchZIndex(Integer zIndex) {
        view.setElevation(zIndex != null ? zIndex : 0);
    }

    protected void patchDisplay(String display) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        String tmpDisplay = display != null ? display : "flex";

        switch (tmpDisplay) {
            case "flex": {
                layoutParams.display = LayoutParams.DISPLAY_FLEX;

                view.setVisibility(View.VISIBLE);

                break;
            }

            case "none": {
                layoutParams.display = LayoutParams.DISPLAY_NONE;

                clearFocus(view);

                view.setVisibility(View.GONE);

                break;
            }
        }
    }

    protected void patchPointerEvents(String pointerEvents) {
    }

    protected void patchObjectFit(String objectFit) {
    }

    protected void patchOverflow(String overflow) {}

    protected void patchOpacity(Float opacity) {
        view.setAlpha(opacity != null ? opacity : 1);
    }

    protected void patchAspectRatio(Float aspectRatio) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.aspectRatio = aspectRatio;
    }

    protected void patchBorderWidth(Float borderWidth) {
    }

    protected void patchBorderColor(Object borderColor) {
    }

    protected void patchBorderTopWidth(Float borderTopWidth) {
    }

    protected void patchBorderTopColor(Object borderTopColor) {
    }

    protected void patchBorderLeftWidth(Float borderLeftWidth) {
    }

    protected void patchBorderLeftColor(Object borderLeftColor) {
    }

    protected void patchBorderBottomWidth(Float borderBottomWidth) {
    }

    protected void patchBorderBottomColor(Object borderBottomColor) {
    }

    protected void patchBorderRightWidth(Float borderRightWidth) {
    }

    protected void patchBorderRightColor(Object borderRightColor) {
    }

    protected void patchTransform(StyleTransform transform) {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.onLayoutClosures.put("transform", () -> {
            float translateX = 0;
            float translateY = 0;

            float scaleX = 1;
            float scaleY = 1;

            if (transform != null) {
                if (transform.translateX != null) {
                    translateX = getTranslate(view.getWidth(), transform.translateX);
                }

                if (transform.translateY != null) {
                    translateY = getTranslate(view.getHeight(), transform.translateY);
                }

                if (transform.scale != null) {
                    float scale = getScale(transform.scale);

                    scaleX = scale;
                    scaleY = scale;
                }

                if (transform.scaleX != null) {
                    scaleX = getScale(transform.scaleX);
                }

                if (transform.scaleY != null) {
                    scaleY = getScale(transform.scaleY);
                }
            }

            view.setTranslationX(translateX);
            view.setTranslationY(translateY);

            view.setScaleX(scaleX);
            view.setScaleY(scaleY);
        });
    }

    protected float getTranslate(int size, Object translateValue) {
        if (translateValue instanceof Double) {
            return PixelHelper.dpToPx((Double) translateValue);
        } else if (translateValue instanceof String) {
            float percent = AttributeHelper.convertPercentStringToFloat((String) translateValue);

            return size * percent;
        }

        return 0;
    }

    protected float getScale(Object scaleValue) {
        if (scaleValue instanceof Double) {
            return ((Double) scaleValue).floatValue();
        } else if (scaleValue instanceof String) {
            return AttributeHelper.convertPercentStringToFloat((String) scaleValue);
        }

        return 0;
    }

    public void applyStyle(Style style, List<String> keys) {
        Styler styler = new Styler(style);

        Integer flex = styler.getFlex();
        String flexDirection = styler.getFlexDirection();
        String justifyContent = styler.getJustifyContent();
        String alignItems = styler.getAlignItems();
        String alignSelf = styler.getAlignSelf();
        Object backgroundColor = styler.getBackgroundColor();
        Object width = styler.getWidth();
        Object height = styler.getHeight();
        Object minWidth = styler.getMinWidth();
        Object minHeight = styler.getMinHeight();
        Object maxWidth = styler.getMaxWidth();
        Object maxHeight = styler.getMaxHeight();
        Float padding = styler.getPadding();
        Float paddingHorizontal = styler.getPaddingHorizontal();
        Float paddingVertical = styler.getPaddingVertical();
        Float paddingTop = styler.getPaddingTop();
        Float paddingLeft = styler.getPaddingLeft();
        Float paddingBottom = styler.getPaddingBottom();
        Float paddingRight = styler.getPaddingRight();
        Float margin = styler.getMargin();
        Float marginHorizontal = styler.getMarginHorizontal();
        Float marginVertical = styler.getMarginVertical();
        Float marginTop = styler.getMarginTop();
        Float marginLeft = styler.getMarginLeft();
        Float marginBottom = styler.getMarginBottom();
        Float marginRight = styler.getMarginRight();
        Float fontSize = styler.getFontSize();
        Float lineHeight = styler.getLineHeight();
        String fontWeight = styler.getFontWeight();
        Object color = styler.getColor();
        String textAlign = styler.getTextAlign();
        String textDecoration = styler.getTextDecoration();
        String textTransform = styler.getTextTransform();
        String textOverflow = styler.getTextOverflow();
        String overflowWrap = styler.getOverflowWrap();
        String wordBreak = styler.getWordBreak();
        String position = styler.getPosition();
        Float top = styler.getTop();
        Float left = styler.getLeft();
        Float bottom = styler.getBottom();
        Float right = styler.getRight();
        Integer zIndex = styler.getZIndex();
        String display = styler.getDisplay();
        String pointerEvents = styler.getPointerEvents();
        String objectFit = styler.getObjectFit();
        String overflow = styler.getOverflow();
        Float opacity = styler.getOpacity();
        Float aspectRatio = styler.getAspectRatio();
        Object borderRadius = styler.getBorderRadius();
        Object borderRadiusTopLeft = styler.getBorderRadiusTopLeft();
        Object borderRadiusTopRight = styler.getBorderRadiusTopRight();
        Object borderRadiusBottomLeft = styler.getBorderRadiusBottomLeft();
        Object borderRadiusBottomRight = styler.getBorderRadiusBottomRight();
        Float borderWidth = styler.getBorderWidth();
        Object borderColor = styler.getBorderColor();
        Float borderTopWidth = styler.getBorderTopWidth();
        Object borderTopColor = styler.getBorderTopColor();
        Float borderLeftWidth = styler.getBorderLeftWidth();
        Object borderLeftColor = styler.getBorderLeftColor();
        Float borderBottomWidth = styler.getBorderBottomWidth();
        Object borderBottomColor = styler.getBorderBottomColor();
        Float borderRightWidth = styler.getBorderRightWidth();
        Object borderRightColor = styler.getBorderRightColor();
        StyleTransform transform = styler.getTransform();

        boolean patchFlex = keys.contains("flex");
        boolean patchFlexDirection = keys.contains("flexDirection");
        boolean patchJustifyContent = keys.contains("justifyContent");
        boolean patchAlignItems = keys.contains("alignItems");
        boolean patchAlignSelf = keys.contains("alignSelf");
        boolean patchBackgroundColor = keys.contains("backgroundColor");
        boolean patchWidth = keys.contains("width");
        boolean patchHeight = keys.contains("height");
        boolean patchMinWidth = keys.contains("minWidth");
        boolean patchMinHeight = keys.contains("minHeight");
        boolean patchMaxWidth = keys.contains("maxWidth");
        boolean patchMaxHeight = keys.contains("maxHeight");
        boolean patchPadding = keys.contains("padding");
        boolean patchPaddingHorizontal = keys.contains("paddingHorizontal");
        boolean patchPaddingVertical = keys.contains("paddingVertical");
        boolean patchPaddingTop = keys.contains("paddingTop");
        boolean patchPaddingLeft = keys.contains("paddingLeft");
        boolean patchPaddingBottom = keys.contains("paddingBottom");
        boolean patchPaddingRight = keys.contains("paddingRight");
        boolean patchMargin = keys.contains("margin");
        boolean patchMarginHorizontal = keys.contains("marginHorizontal");
        boolean patchMarginVertical = keys.contains("marginVertical");
        boolean patchMarginTop = keys.contains("marginTop");
        boolean patchMarginLeft = keys.contains("marginLeft");
        boolean patchMarginBottom = keys.contains("marginBottom");
        boolean patchMarginRight = keys.contains("marginRight");
        boolean patchFontSize = keys.contains("fontSize");
        boolean patchLineHeight = keys.contains("lineHeight");
        boolean patchFontWeight = keys.contains("fontWeight");
        boolean patchColor = keys.contains("color");
        boolean patchTextAlign = keys.contains("textAlign");
        boolean patchTextDecoration = keys.contains("textDecoration");
        boolean patchTextTransform = keys.contains("textTransform");
        boolean patchTextOverflow = keys.contains("textOverflow");
        boolean patchOverflowWrap = keys.contains("overflowWrap");
        boolean patchWordBreak = keys.contains("wordBreak");
        boolean patchPosition = keys.contains("position");
        boolean patchTop = keys.contains("top");
        boolean patchLeft = keys.contains("left");
        boolean patchBottom = keys.contains("bottom");
        boolean patchRight = keys.contains("right");
        boolean patchZIndex = keys.contains("zIndex");
        boolean patchDisplay = keys.contains("display");
        boolean patchPointerEvents = keys.contains("pointerEvents");
        boolean patchObjectFit = keys.contains("objectFit");
        boolean patchOverflow = keys.contains("overflow");
        boolean patchOpacity = keys.contains("opacity");
        boolean patchAspectRatio = keys.contains("aspectRatio");
        boolean patchBorderRadius = keys.contains("borderRadius");
        boolean patchBorderRadiusTopLeft = keys.contains("borderRadiusTopLeft");
        boolean patchBorderRadiusTopRight = keys.contains("borderRadiusTopRight");
        boolean patchBorderRadiusBottomLeft = keys.contains("borderRadiusBottomLeft");
        boolean patchBorderRadiusBottomRight = keys.contains("borderRadiusBottomRight");
        boolean patchBorderWidth = keys.contains("borderWidth");
        boolean patchBorderColor = keys.contains("borderColor");
        boolean patchBorderTopWidth = keys.contains("borderTopWidth");
        boolean patchBorderTopColor = keys.contains("borderTopColor");
        boolean patchBorderLeftWidth = keys.contains("borderLeftWidth");
        boolean patchBorderLeftColor = keys.contains("borderLeftColor");
        boolean patchBorderBottomWidth = keys.contains("borderBottomWidth");
        boolean patchBorderBottomColor = keys.contains("borderBottomColor");
        boolean patchBorderRightWidth = keys.contains("borderRightWidth");
        boolean patchBorderRightColor = keys.contains("borderRightColor");
        boolean patchTransform = keys.contains("transform");

        if (patchFlex) {
            patchFlex(flex);
        }

        if (patchFlexDirection) {
            patchFlexDirection(flexDirection);
        }

        if (patchJustifyContent) {
            patchJustifyContent(justifyContent);
        }

        if (patchAlignItems) {
            patchAlignItems(alignItems);
        }

        if (patchAlignSelf) {
            patchAlignSelf(alignSelf);
        }

        if (
                patchBackgroundColor
                        || patchBorderRadius
                        || patchBorderRadiusTopLeft
                        || patchBorderRadiusTopRight
                        || patchBorderRadiusBottomLeft
                        || patchBorderRadiusBottomRight
        ) {
            patchBackgroundColor(
                    patchBackgroundColor ? backgroundColor : this.styler.getBackgroundColor(),
                    patchBorderRadius ? borderRadius : this.styler.getBorderRadius(),
                    patchBorderRadiusTopLeft ? borderRadiusTopLeft : this.styler.getBorderRadiusTopLeft(),
                    patchBorderRadiusTopRight ? borderRadiusTopRight : this.styler.getBorderRadiusTopRight(),
                    patchBorderRadiusBottomLeft ? borderRadiusBottomLeft : this.styler.getBorderRadiusBottomLeft(),
                    patchBorderRadiusBottomRight ? borderRadiusBottomRight : this.styler.getBorderRadiusBottomRight()
            );
        }

        if (patchWidth) {
            patchWidth(width);
        }

        if (patchHeight) {
            patchHeight(height);
        }

        if (patchMinWidth) {
            patchMinWidth(minWidth);
        }

        if (patchMinHeight) {
            patchMinHeight(minHeight);
        }

        if (patchMaxWidth) {
            patchMaxWidth(maxWidth);
        }

        if (patchMaxHeight) {
            patchMaxHeight(maxHeight);
        }

        if (
                patchPadding
                        || patchPaddingHorizontal
                        || patchPaddingVertical
                        || patchPaddingTop
                        || patchPaddingLeft
                        || patchPaddingBottom
                        || patchPaddingRight
        ) {
            patchPadding(
                    patchPadding ? padding : this.styler.getPadding(),
                    patchPaddingHorizontal ? paddingHorizontal : this.styler.getPaddingHorizontal(),
                    patchPaddingVertical ? paddingVertical : this.styler.getPaddingVertical(),
                    patchPaddingTop ? paddingTop : this.styler.getPaddingTop(),
                    patchPaddingLeft ? paddingLeft : this.styler.getPaddingLeft(),
                    patchPaddingBottom ? paddingBottom : this.styler.getPaddingBottom(),
                    patchPaddingRight ? paddingRight : this.styler.getPaddingRight()
            );
        }

        if (
                patchMargin
                        || patchMarginHorizontal
                        || patchMarginVertical
                        || patchMarginTop
                        || patchMarginLeft
                        || patchMarginBottom
                        || patchMarginRight
        ) {
            patchMargin(
                    patchMargin ? margin: this.styler.getMargin(),
                    patchMarginHorizontal ? marginHorizontal : this.styler.getMarginHorizontal(),
                    patchMarginVertical ? marginVertical : this.styler.getMarginVertical(),
                    patchMarginTop ? marginTop : this.styler.getMarginTop(),
                    patchMarginLeft ? marginLeft : this.styler.getMarginLeft(),
                    patchMarginBottom ? marginBottom : this.styler.getMarginBottom(),
                    patchMarginRight ? marginRight : this.styler.getMarginRight()
            );
        }

        if (patchFontSize) {
            patchFontSize(fontSize);
        }

        if (patchLineHeight) {
            patchLineHeight(lineHeight);
        }

        if (patchFontWeight) {
            patchFontWeight(fontWeight);
        }

        if (patchColor) {
            patchColor(color);
        }

        if (patchTextAlign) {
            patchTextAlign(textAlign);
        }

        if (patchTextDecoration) {
            patchTextDecoration(textDecoration);
        }

        if (patchTextTransform) {
            patchTextTransform(textTransform);
        }

        if (patchTextOverflow) {
            patchTextOverflow(textOverflow);
        }

        if (patchOverflowWrap) {
            patchOverflowWrap(overflowWrap);
        }

        if (patchWordBreak) {
            patchWordBreak(wordBreak);
        }

        if (patchPosition) {
            patchPosition(position);
        }

        if (patchTop) {
            patchTop(top);
        }

        if (patchLeft) {
            patchLeft(left);
        }

        if (patchBottom) {
            patchBottom(bottom);
        }

        if (patchRight) {
            patchRight(right);
        }

        if (patchZIndex) {
            patchZIndex(zIndex);
        }

        if (patchDisplay) {
            patchDisplay(display);
        }

        if (patchPointerEvents) {
            patchPointerEvents(pointerEvents);
        }

        if (patchObjectFit) {
            patchObjectFit(objectFit);
        }

        if (patchOverflow) {
            patchOverflow(overflow);
        }

        if (patchOpacity) {
            patchOpacity(opacity);
        }

        if (patchAspectRatio) {
            patchAspectRatio(aspectRatio);
        }

        if (patchBorderWidth) {
            patchBorderWidth(borderWidth);
        }

        if (patchBorderColor) {
            patchBorderColor(borderColor);
        }

        if (patchBorderTopWidth) {
            patchBorderTopWidth(borderTopWidth);
        }

        if (patchBorderTopColor) {
            patchBorderTopColor(borderTopColor);
        }

        if (patchBorderLeftWidth) {
            patchBorderLeftWidth(borderLeftWidth);
        }

        if (patchBorderLeftColor) {
            patchBorderLeftColor(borderLeftColor);
        }

        if (patchBorderBottomWidth) {
            patchBorderBottomWidth(borderBottomWidth);
        }

        if (patchBorderBottomColor) {
            patchBorderBottomColor(borderBottomColor);
        }

        if (patchBorderRightWidth) {
            patchBorderRightWidth(borderRightWidth);
        }

        if (patchBorderRightColor) {
            patchBorderRightColor(borderRightColor);
        }

        if (patchTransform) {
            patchTransform(transform);
        }
    }

    protected abstract K createView();
    protected abstract void patchView();

    private void clearFocus(View view) {
        if (view instanceof ViewGroup) {
            ViewGroup viewGroup = (ViewGroup) view;

            for (int i = 0; i < viewGroup.getChildCount(); i++) {
                View child = viewGroup.getChildAt(i);

                clearFocus(child);
            }
        }

        if (view.hasFocus()) {
            view.clearFocus();

            if (view instanceof EditText) {
                view.post(() -> {
                    InputMethodManager imm = (InputMethodManager) ContextHelper.context.getSystemService(Context.INPUT_METHOD_SERVICE);

                    imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
                });
            }
        }
    }

    public static class Attributes {
        public Style style;
        public Boolean onTap;
        public Boolean onDoubleTap;
    }
}
