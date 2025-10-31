import { Detonator } from "../Detonator";

export class Toast {
  public static async show(
    text: string,
    isShort: boolean = true
  ): Promise<void> {
    await Detonator.request("com.iconshot.detonator.toast::show", {
      text,
      isShort,
    }).fetch();
  }
}
