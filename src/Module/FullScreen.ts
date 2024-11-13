import { Detonator } from "../Detonator";

import { View } from "../Component/View";

export class FullScreen {
  static async open(view: View): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.fullscreen/open" },
      view
    );
  }

  static async close(): Promise<void> {
    await Detonator.request({
      name: "com.iconshot.detonator.fullscreen/close",
    });
  }
}
