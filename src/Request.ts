import { Component } from "untrue";

import { Detonator } from "./Detonator";

import { MessageFormatter } from "./MessageFormatter";

export class Request {
  private static fetchId: number = 0;

  private elementOrComponent: Element | Component | null = null;

  constructor(private name: string, protected data: any) {}

  public withEdge(elementOrComponent: Element | Component): Request {
    if (
      !(
        elementOrComponent instanceof Element ||
        elementOrComponent instanceof Component
      )
    ) {
      throw new Error("Invalid element or component type.");
    }

    this.elementOrComponent = elementOrComponent;

    return this;
  }

  public async fetch(): Promise<string> {
    const fetchId = Request.fetchId++;

    let edgeId: number | null = null;

    if (this.elementOrComponent !== null) {
      if (this.elementOrComponent instanceof Element) {
        edgeId = Detonator.getElementId(this.elementOrComponent);

        if (edgeId === null) {
          throw new Error("Element is not mounted.");
        }
      } else if (this.elementOrComponent instanceof Component) {
        edgeId = Detonator.getComponentId(this.elementOrComponent);

        if (edgeId === null) {
          throw new Error("Component is not mounted.");
        }
      }
    }

    const requestValue = MessageFormatter.join([
      `${fetchId}`,
      `${edgeId ?? "-"}`,
      this.name,
      this.data,
    ]);

    return new Promise<string>((resolve, reject): void => {
      const resolveListener = (value: string): boolean => {
        const [tmpFetchId, resultValue] = MessageFormatter.split(value, 2);

        const parsedFetchId = parseInt(tmpFetchId);

        if (parsedFetchId !== fetchId) {
          return true;
        }

        resolve(resultValue);

        cleanUp();

        return false;
      };

      const rejectListener = (value: string): boolean => {
        const [tmpFetchId, message] = MessageFormatter.split(value, 2);

        const parsedFetchId = parseInt(tmpFetchId);

        if (parsedFetchId !== fetchId) {
          return true;
        }

        reject(new Error(message));

        cleanUp();

        return false;
      };

      const cleanUp = (): void => {
        Detonator.emitter.off(
          "com.iconshot.detonator.request.fetch::resolve",
          resolveListener
        );

        Detonator.emitter.off(
          "com.iconshot.detonator.request.fetch::reject",
          rejectListener
        );
      };

      Detonator.emitter.on(
        "com.iconshot.detonator.request.fetch::resolve",
        resolveListener
      );

      Detonator.emitter.on(
        "com.iconshot.detonator.request.fetch::reject",
        rejectListener
      );

      Detonator.send("com.iconshot.detonator.request::fetch", requestValue);
    });
  }

  public async fetchAndDecode(): Promise<any> {
    const value = await this.fetch();

    return JSON.parse(value);
  }
}
