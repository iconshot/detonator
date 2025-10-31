import { Detonator } from "../Detonator";

import { View } from "../UI/View";

export class FullScreen {
  private static requestAnimationFrame:
    | typeof window.requestAnimationFrame
    | undefined;

  private static cancelAnimationFrame:
    | typeof window.cancelAnimationFrame
    | undefined;

  public static async open(view: View): Promise<void> {
    if (!(view instanceof View)) {
      throw new Error("Not a View component.");
    }

    this.requestAnimationFrame = window.requestAnimationFrame;
    this.cancelAnimationFrame = window.cancelAnimationFrame;

    const windowAny = window as any;

    windowAny.requestAnimationFrame = undefined;
    windowAny.cancelAnimationFrame = undefined;

    await Detonator.request("com.iconshot.detonator.fullscreen::open")
      .withEdge(view)
      .fetch();
  }

  public static async close(): Promise<void> {
    window.requestAnimationFrame = this.requestAnimationFrame!;
    window.cancelAnimationFrame = this.cancelAnimationFrame!;

    this.requestAnimationFrame = undefined;
    this.cancelAnimationFrame = undefined;

    await Detonator.request("com.iconshot.detonator.fullscreen::close").fetch();
  }
}
