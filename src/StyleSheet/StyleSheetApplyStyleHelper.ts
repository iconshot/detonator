import { Detonator } from "../Detonator";

import { BaseView } from "../UI/BaseView";

import { Style } from "./StyleSheet";

import { StyleSheetHelper, StyleEntry } from "./StyleSheetHelper";

interface ElementStyleEntry {
  elementId: number;
  styleEntries: StyleEntry[];
}

export class StyleSheetApplyStyleHelper {
  private static elementStyleEntries: Map<number, ElementStyleEntry> =
    new Map();

  private static timeout: number | undefined;

  public static applyStyle(view: BaseView, style: Style): void {
    const componentId = Detonator.getComponentId(view);

    if (componentId === null) {
      throw new Error("Component is not mounted.");
    }

    const componentEdge = Detonator.getEdge(componentId)!;

    const elementEdge = componentEdge.children[0]!;

    const elementId = elementEdge.id;

    let elementStyleEntry = this.elementStyleEntries.get(elementId);

    if (elementStyleEntry === undefined) {
      elementStyleEntry = {
        elementId,
        styleEntries: [],
      };
    }

    const styleEntry = StyleSheetHelper.createStyleEntry(style);

    elementStyleEntry.styleEntries.push(styleEntry);

    this.elementStyleEntries.set(elementId, elementStyleEntry);

    clearTimeout(this.timeout);

    this.timeout = setTimeout((): void => {
      const elementStyleEntries: ElementStyleEntry[] = [];

      this.elementStyleEntries.forEach((elementStyleEntry, elementId): void => {
        if (!Detonator.hasEdge(elementId)) {
          return;
        }

        elementStyleEntries.push(elementStyleEntry);
      });

      this.elementStyleEntries.clear();

      if (elementStyleEntries.length === 0) {
        return;
      }

      Detonator.send(
        "com.iconshot.detonator.stylesheet::applyStyle",
        elementStyleEntries
      );
    });
  }
}
