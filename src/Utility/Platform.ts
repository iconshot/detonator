export class Platform {
  public static get(): "ios" | "android" {
    const windowAny = window as any;

    return windowAny.__detonator_platform;
  }
}

if (Platform.get() === "android") {
  window.requestAnimationFrame = undefined as any;
  window.cancelAnimationFrame = undefined as any;
}
