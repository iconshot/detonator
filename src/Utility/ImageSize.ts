import { Detonator } from "../Detonator";

export class ImageSize {
  public static async getSize(
    source: string
  ): Promise<{ width: number; height: number }> {
    return await Detonator.request(
      "com.iconshot.detonator.imagesize::getSize",
      source
    ).fetchAndDecode();
  }
}
