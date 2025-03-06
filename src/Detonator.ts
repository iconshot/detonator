import { Slot, Component, Emitter } from "untrue";

import { TreeHub } from "./Tree/TreeHub";
import { Tree } from "./Tree/Tree";

import { View, Style } from "./Component/View";
import { BaseView } from "./Component/BaseView";

import { HandlerManager } from "./Manager/HandlerManager";

import { Messenger } from "./Messenger";

interface StyleItem {
  elementId: number;
  style: Style;
  keys: string[];
}

type DetonatorKitSignatures = {
  handler: (json: string) => any;
  event: (json: string) => any;
  response: (json: string) => any;
};

class DetonatorKit extends Emitter<DetonatorKitSignatures> {
  private requestId: number = 0;

  private tree: Tree = TreeHub.createTree();

  private styleItems: StyleItem[] = [];

  private styleTimeout: number | undefined;

  public mount(slot: Slot): void {
    this.tree.mount(slot);
  }

  public unmount(): void {
    this.tree.unmount();
  }

  public createTree(view: View): Tree {
    return TreeHub.createTree(view);
  }

  public style(view: BaseView, style: Style): void {
    const componentId = TreeHub.getComponentId(view);

    if (componentId === null) {
      throw new Error("Component is not mounted.");
    }

    const componentEdge = TreeHub.edges.get(componentId)!;

    const elementEdge = componentEdge.children[0]!;

    const elementId = elementEdge.id;

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

  public async request(
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

        this.off("response", listener);
      };

      this.on("response", listener);

      Messenger.request(request);
    });
  }

  public async openUrl(url: string): Promise<void> {
    await this.request({ name: "com.iconshot.detonator/openUrl", data: url });
  }

  public log(...data: any[]): void {
    Messenger.log(data);
  }
}

export const Detonator = new DetonatorKit();

HandlerManager.listen();

const windowAny = window as any;

windowAny.Detonator = Detonator;
