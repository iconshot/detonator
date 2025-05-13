import { StyleSheetHelper } from "./StyleSheetHelper";
import { StyleSheetCreateHelper } from "./StyleSheetCreateHelper";

export type StyleColor =
  | string
  | [number, number, number]
  | [number, number, number, number];

export type StyleSize = string | number;

export interface StyleTransform {
  translateX?: StyleSize | null;
  translateY?: StyleSize | null;
  scale?: StyleSize | null;
  scaleX?: StyleSize | null;
  scaleY?: StyleSize | null;
}

export interface Style {
  flex?: number | null;
  flexDirection?: "row" | "row-reverse" | "column" | "column-reverse" | null;
  justifyContent?:
    | "flex-start"
    | "flex-end"
    | "start"
    | "end"
    | "center"
    | "space-between"
    | "space-around"
    | "space-evenly"
    | null;
  alignItems?: "flex-start" | "flex-end" | "start" | "end" | "center" | null;
  alignSelf?: "flex-start" | "flex-end" | "start" | "end" | "center" | null;
  gap?: number | null;

  backgroundColor?: StyleColor | null;

  width?: StyleSize | null;
  height?: StyleSize | null;
  minWidth?: StyleSize | null;
  minHeight?: StyleSize | null;
  maxWidth?: StyleSize | null;
  maxHeight?: StyleSize | null;

  padding?: number | null;
  paddingHorizontal?: number | null;
  paddingVertical?: number | null;
  paddingTop?: number | null;
  paddingLeft?: number | null;
  paddingBottom?: number | null;
  paddingRight?: number | null;

  margin?: number | null;
  marginHorizontal?: number | null;
  marginVertical?: number | null;
  marginTop?: number | null;
  marginLeft?: number | null;
  marginBottom?: number | null;
  marginRight?: number | null;

  fontSize?: number | null;
  fontStyle?: "normal" | "italic" | null;
  lineHeight?: number | null;
  fontWeight?: "normal" | "bold" | null;
  color?: StyleColor | null;
  textAlign?: "left" | "center" | "right" | "justify" | null;
  textDecoration?: "underline" | "overline" | null;
  textTransform?: "capitalize" | "uppercase" | "lowercase" | null;
  textOverflow?: "clip" | "ellipsis" | null;
  overflowWrap?: "normal" | "break-word" | "anywhere" | null;
  wordBreak?: "normal" | "break-all" | "keep-all" | null;

  position?: "relative" | "absolute" | null;
  top?: StyleSize | null;
  left?: StyleSize | null;
  bottom?: StyleSize | null;
  right?: StyleSize | null;
  zIndex?: number | null;

  display?: "flex" | "none" | null;
  pointerEvents?: "auto" | "none" | null;
  objectFit?: "contain" | "cover" | "fill" | "none" | null;
  overflow?: "visible" | "hidden" | null;
  opacity?: number | null;
  aspectRatio?: number | null;

  borderRadius?: StyleSize | null;
  borderRadiusTopLeft?: StyleSize | null;
  borderRadiusTopRight?: StyleSize | null;
  borderRadiusBottomLeft?: StyleSize | null;
  borderRadiusBottomRight?: StyleSize | null;

  borderWidth?: number | null;
  borderColor?: StyleColor | null;

  borderTopWidth?: number | null;
  borderTopColor?: StyleColor | null;

  borderLeftWidth?: number | null;
  borderLeftColor?: StyleColor | null;

  borderBottomWidth?: number | null;
  borderBottomColor?: StyleColor | null;

  borderRightWidth?: number | null;
  borderRightColor?: StyleColor | null;

  transform?: StyleTransform | null;
}

export class StyleSheet {
  public static create<T extends Record<string, Style>>(
    styles: T
  ): { [K in keyof T]: number } {
    const result = {} as { [K in keyof T]: number };

    for (const key in styles) {
      const style = styles[key];

      const styleEntryId = StyleSheetCreateHelper.styleEntryId++;

      result[key] = styleEntryId;

      const styleEntry = StyleSheetHelper.createStyleEntry(style);

      StyleSheetCreateHelper.styleEntries.set(styleEntryId, styleEntry);
    }

    return result;
  }
}
