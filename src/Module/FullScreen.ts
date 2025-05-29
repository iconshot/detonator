import { Detonator } from "../Detonator";

import { View } from "../Component/View";

export class FullScreen {
  private static requestAnimationFrame:
    | typeof window.requestAnimationFrame
    | undefined;

  private static cancelAnimationFrame:
    | typeof window.cancelAnimationFrame
    | undefined;

  static async open(view: View): Promise<void> {
    this.requestAnimationFrame = window.requestAnimationFrame;
    this.cancelAnimationFrame = window.cancelAnimationFrame;

    const windowAny = window as any;

    windowAny.requestAnimationFrame = undefined;
    windowAny.cancelAnimationFrame = undefined;

    await Detonator.request(
      { name: "com.iconshot.detonator.fullscreen::open" },
      view
    );
  }

  static async close(): Promise<void> {
    window.requestAnimationFrame = this.requestAnimationFrame!;
    window.cancelAnimationFrame = this.cancelAnimationFrame!;

    this.requestAnimationFrame = undefined;
    this.cancelAnimationFrame = undefined;

    await Detonator.request({
      name: "com.iconshot.detonator.fullscreen::close",
    });
  }
}
