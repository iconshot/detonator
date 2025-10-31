import { Detonator } from "../Detonator";

import { BaseView } from "../UI/BaseView";

import { Style } from "./StyleSheet";

interface ElementRemoveStyleEntry {
  elementId: number;
  toRemoveKeys: (string[] | null)[];
}

export class StyleSheetRemoveStyleHelper {
  private static elementRemoveStyleEntries: Map<
    number,
    ElementRemoveStyleEntry
  > = new Map();

  private static timeout: number | undefined;

  public static removeStyle<K extends keyof Style>(
    view: BaseView,
    key: K | K[] | null
  ): void {
    const componentId = Detonator.getComponentId(view);

    if (componentId === null) {
      throw new Error("Component is not mounted.");
    }

    const componentEdge = Detonator.getEdge(componentId)!;

    const elementEdge = componentEdge.children[0]!;

    const elementId = elementEdge.id;

    let elementRemoveStyleEntry = this.elementRemoveStyleEntries.get(elementId);

    if (elementRemoveStyleEntry === undefined) {
      elementRemoveStyleEntry = {
        elementId,
        toRemoveKeys: [],
      };
    }

    let keys: string[] | null = null;

    if (key !== null) {
      keys = Array.isArray(key) ? key : [key];
    }

    elementRemoveStyleEntry.toRemoveKeys.push(keys);

    this.elementRemoveStyleEntries.set(elementId, elementRemoveStyleEntry);

    clearTimeout(this.timeout);

    this.timeout = setTimeout((): void => {
      const elementRemoveStyleEntries: ElementRemoveStyleEntry[] = [];

      this.elementRemoveStyleEntries.forEach(
        (elementRemoveStyleEntry, elementId): void => {
          if (!Detonator.hasEdge(elementId)) {
            return;
          }

          elementRemoveStyleEntries.push(elementRemoveStyleEntry);
        }
      );

      this.elementRemoveStyleEntries.clear();

      if (elementRemoveStyleEntries.length === 0) {
        return;
      }

      Detonator.send(
        "com.iconshot.detonator.stylesheet::removeStyle",
        elementRemoveStyleEntries
      );
    });
  }
}
