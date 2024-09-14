import { Color as PalettoColor } from "@paletto/color";

export class Color extends PalettoColor {
  public rgba(value: number, alpha: number): [number, number, number, number] {
    if (alpha < 0 || alpha > 1) {
      throw new Error("Color alpha should be between 0 and 1.");
    }

    const rgb = this.rgb(value);

    return [...rgb, alpha];
  }
}
