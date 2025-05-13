package com.iconshot.detonator.module.stylesheet;

public class Style {
    // flex

    public Integer flex;
    public String flexDirection;
    public String justifyContent;
    public String alignItems;
    public String alignSelf;
    public Float gap;

    // bg

    public Object backgroundColor;

    // size

    public Object width;
    public Object height;
    public Object minWidth;
    public Object minHeight;
    public Object maxWidth;
    public Object maxHeight;

    // padding

    public Float padding;
    public Float paddingHorizontal;
    public Float paddingVertical;
    public Float paddingTop;
    public Float paddingLeft;
    public Float paddingBottom;
    public Float paddingRight;

    // margin

    public Float margin;
    public Float marginHorizontal;
    public Float marginVertical;
    public Float marginTop;
    public Float marginLeft;
    public Float marginBottom;
    public Float marginRight;

    // text

    public Float fontSize;
    public Float lineHeight;
    public String fontWeight;
    public Object color;
    public String textAlign;
    public String textDecoration;
    public String textTransform;
    public String textOverflow;
    public String overflowWrap;
    public String wordBreak;

    // position

    public String position;
    public Object top;
    public Object left;
    public Object bottom;
    public Object right;
    public Integer zIndex;

    // misc

    public String display;
    public String pointerEvents;
    public String objectFit;
    public String overflow;
    public Float opacity;
    public Float aspectRatio;

    // border radius

    public Object borderRadius;
    public Object borderRadiusTopLeft;
    public Object borderRadiusTopRight;
    public Object borderRadiusBottomLeft;
    public Object borderRadiusBottomRight;

    // border

    public Float borderWidth;
    public Object borderColor;

    public Float borderTopWidth;
    public Object borderTopColor;

    public Float borderLeftWidth;
    public Object borderLeftColor;

    public Float borderBottomWidth;
    public Object borderBottomColor;

    public Float borderRightWidth;
    public Object borderRightColor;

    // transform

    public StyleTransform transform;

    public static class StyleTransform {
        public Object translateX;
        public Object translateY;
        public Object scale;
        public Object scaleX;
        public Object scaleY;
    }
}