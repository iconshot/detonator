import { Slot, Component } from "untrue";

import { TreeHub } from "./Tree/TreeHub";
import { Tree } from "./Tree/Tree";

import { View, Style } from "./Component/View";
import { BaseView } from "./Component/BaseView";

import { Messenger } from "./Messenger";
import { WindowEmitter } from "./Emitter";

interface StyleItem {
  elementId: number;
  style: Style;
  keys: string[];
}

export class Detonator {
  private static requestId: number = 0;

  private static tree: Tree = TreeHub.createTree();

  private static styleItems: StyleItem[] = [];

  private static styleTimeout: number | undefined;

  public static mount(slot: Slot): void {
    this.tree.mount(slot);
  }

  public static unmount(): void {
    this.tree.unmount();
  }

  public static createTree(view: View): Tree {
    return TreeHub.createTree(view);
  }

  public static style(view: BaseView, style: Style): void {
    const componentId = TreeHub.getComponentId(view);

    if (componentId === null) {
      throw new Error("Component is not mounted.");
    }

    const componentEdge = TreeHub.edges.get(componentId)!;

    const elementEdge = componentEdge.children[0]!;

    const elementId = elementEdge.id!;

    const keys = Object.keys(style);

    if (keys.length === 0) {
      return;
    }

    let styleItem = this.styleItems.find(
      (styleItem): boolean => styleItem.elementId === elementId
    );

    if (styleItem === undefined) {
      styleItem = { elementId, style, keys };

      this.styleItems.push(styleItem);
    } else {
      styleItem.style = { ...styleItem.style, ...style };

      styleItem.keys = [
        ...styleItem.keys,
        ...keys.filter((key) => !styleItem!.keys.includes(key)),
      ];
    }

    clearTimeout(this.styleTimeout);

    this.styleTimeout = setTimeout((): void => {
      const styleItems = this.styleItems.filter((styleItem): boolean =>
        TreeHub.edges.has(styleItem.elementId)
      );

      this.styleItems = [];

      if (styleItems.length === 0) {
        return;
      }

      Messenger.style(styleItems);
    });
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

      const listener = (json: string): void => {
        const response: {
          id: number;
          data: any;
          error: { message: string } | null;
        } = JSON.parse(json);

        if (response.id !== request.id) {
          return;
        }

        if (response.error !== null) {
          reject(new Error(response.error.message));
        } else {
          resolve(response.data);
        }

        WindowEmitter.off("response", listener);
      };

      WindowEmitter.on("response", listener);

      Messenger.request(request);
    });
  }

  public static async openUrl(url: string): Promise<void> {
    await this.request({ name: "com.iconshot.detonator/openUrl", data: url });
  }

  public static log(...data: any[]): void {
    Messenger.log(data);
  }
}
