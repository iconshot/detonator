import { StyleAttribute } from "../Component/View";

import { Style } from "./StyleSheet";

type CombinedStyleArray = (number | string | null)[];

export interface StyleEntry {
  style: Style;
  keys: string[];
}

export class StyleSheetHelper {
  public static createStyleEntry(style: Style): StyleEntry {
    const keys = Object.keys(style);

    return { style, keys };
  }

  public static combineAllStyles(
    style: StyleAttribute,
    styles: CombinedStyleArray
  ): void {
    if (Array.isArray(style)) {
      style.forEach((tmpStyle): void => {
        this.combineAllStyles(tmpStyle, styles);
      });

      return;
    }

    if (style === null) {
      styles.push(null);

      return;
    }

    if (style === undefined) {
      styles.push(null);

      return;
    }

    if (Number.isInteger(style)) {
      styles.push(style as number);

      return;
    }

    const styleEntry = StyleSheetHelper.createStyleEntry(style as Style);

    const encodedStyleEntry = JSON.stringify(styleEntry);

    styles.push(encodedStyleEntry);
  }

  public static combineStyles(style: StyleAttribute): CombinedStyleArray {
    const styles: CombinedStyleArray = [];

    this.combineAllStyles(style, styles);

    return styles;
  }
}
