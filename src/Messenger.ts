export class Messenger {
  static postMessage(action: string, data: any): void {
    const message = JSON.stringify({ action, data: JSON.stringify(data) });

    const windowAny = window as any;

    if (windowAny.DetonatorBridge !== undefined) {
      windowAny.DetonatorBridge.postMessage(message);

      return;
    }

    windowAny.webkit.messageHandlers.DetonatorBridge.postMessage(message);
  }

  static treeInit(data: any): void {
    this.postMessage("treeInit", data);
  }

  static treeDeinit(data: any): void {
    this.postMessage("treeDeinit", data);
  }

  static mount(data: any): void {
    this.postMessage("mount", data);
  }

  static unmount(data: any): void {
    this.postMessage("unmount", data);
  }

  static rerender(data: any): void {
    this.postMessage("rerender", data);
  }

  static style(data: any): void {
    this.postMessage("style", data);
  }

  static request(data: any): void {
    this.postMessage("request", data);
  }

  static log(data: any): void {
    this.postMessage("log", data);
  }
}
