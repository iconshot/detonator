import { Detonator } from "../Detonator";

export class Toast {
  static async show(text: string, isShort: boolean = true): Promise<void> {
    await Detonator.request({
      name: "com.iconshot.detonator.toast/show",
      data: { text, isShort },
    });
  }
}
