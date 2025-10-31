import { Component, Emitter } from "untrue";

import { HandlerManager } from "./Manager/HandlerManager";

import { Edge } from "./Tree/Edge";
import { TreeRegistry } from "./Tree/TreeRegistry";

import { Request } from "./Request";

import { MessageFormatter } from "./MessageFormatter";

type EmitterSignatures = Record<string, (value: string) => any>;

export class Detonator {
  public static emitter: Emitter<EmitterSignatures> = new Emitter();

  public static send(name: string, data?: any): void {
    const message = MessageFormatter.join([name, data]);

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

  public static request(name: string, data?: any): Request {
    return new Request(name, data);
  }

  public static async openUrl(url: string): Promise<void> {
    await this.request("com.iconshot.detonator::openUrl", url).fetch();
  }

  public static hasEdge(edgeId: number): boolean {
    return TreeRegistry.edges.has(edgeId);
  }

  public static getEdge(edgeId: number): Edge | null {
    return TreeRegistry.edges.get(edgeId) ?? null;
  }

  public static getComponentId(component: Component): number | null {
    return TreeRegistry.components.get(component)?.id ?? null;
  }

  public static getElementId(element: Element): number | null {
    return TreeRegistry.elements.get(element)?.id ?? null;
  }
}

const windowAny = window as any;

windowAny.Detonator = Detonator;

HandlerManager.listen();
