import { Slot, Component, Emitter } from "untrue";

import { TreeHub } from "./Tree/TreeHub";
import { Tree } from "./Tree/Tree";

import { View } from "./Component/View";

import { HandlerManager } from "./Manager/HandlerManager";

import { StyleSheetCreateHelper } from "./StyleSheet/StyleSheetCreateHelper";

type EmitterSignatures = Record<string, (value: string) => any>;

export class Detonator {
  public static emitter: Emitter<EmitterSignatures> = new Emitter();

  private static requestId: number = 0;

  private static tree: Tree = TreeHub.createTree();

  public static mount(slot: Slot): void {
    StyleSheetCreateHelper.send();

    this.tree.mount(slot);
  }

  public static unmount(): void {
    this.tree.unmount();
  }

  public static createTree(view: View): Tree {
    return TreeHub.createTree(view);
  }

  public static send(name: string, data: any): void {
    let message = "";

    message += name;
    message += "\n";

    if (typeof data === "string") {
      message += data;
    } else {
      message += JSON.stringify(data ?? null);
    }

    const windowAny = window as any;

    if (windowAny.DetonatorBridge !== undefined) {
      windowAny.DetonatorBridge.postMessage(message);

      return;
    }

    windowAny.webkit.messageHandlers.DetonatorBridge.postMessage(message);
  }

  public static log(...data: any[]): void {
    this.send("com.iconshot.detonator::log", data);
  }

  public static async request(
    {
      name,
      data = null,
    }: {
      name: string;
      data?: any;
    },
    component: Component | null = null
  ): Promise<any> {
    let componentId: number | null = null;

    if (component !== null) {
      componentId = TreeHub.getComponentId(component);

      if (componentId === null) {
        throw new Error("Component is not mounted.");
      }
    }

    return new Promise<any>((resolve, reject): void => {
      const request = {
        id: this.requestId++,
        name,
        data: data !== null ? JSON.stringify(data) : null,
        componentId,
      };

      const listener = (value: string): boolean => {
        const response: {
          id: number;
          data: any;
          error: { message: string } | null;
        } = JSON.parse(value);

        if (response.id !== request.id) {
          return true;
        }

        if (response.error !== null) {
          reject(new Error(response.error.message));
        } else {
          resolve(response.data);
        }

        this.emitter.off("com.iconshot.detonator.request.response", listener);

        return false;
      };

      this.emitter.on("com.iconshot.detonator.request.response", listener);

      this.send("com.iconshot.detonator.request::init", request);
    });
  }

  public static async openUrl(url: string): Promise<void> {
    await this.request({ name: "com.iconshot.detonator::openUrl", data: url });
  }
}

const windowAny = window as any;

windowAny.Detonator = Detonator;

HandlerManager.listen();
