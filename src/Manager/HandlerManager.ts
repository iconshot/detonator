import { Detonator } from "../Detonator";

import { TreeHub } from "../Tree/TreeHub";

export class HandlerManager {
  public static listen(): void {
    Detonator.emitter.on(
      "com.iconshot.detonator.handler",
      (value: string): void => {
        const {
          name,
          edgeId,
          data,
        }: {
          name: string;
          edgeId: number;
          data: { [key: string]: any } | null;
        } = JSON.parse(value);

        const eventName = this.getEventName(name);

        const edge = TreeHub.edges.get(edgeId) ?? null;

        if (edge === null) {
          return;
        }

        const event = new Event(eventName, { bubbles: true });

        if (data !== null) {
          for (const key in data) {
            event[key] = data[key];
          }
        }

        edge.element!.dispatchEvent(event);
      }
    );
  }

  public static isHandlerName(name: string): boolean {
    return /^on[A-Z]/.test(name);
  }

  public static getEventName(name: string): string {
    return name.substring(2).toLocaleLowerCase();
  }
}
