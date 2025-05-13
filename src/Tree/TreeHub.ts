import { Component } from "untrue";

import { View } from "../Component/View";

import { Edge } from "./Edge";
import { Tree } from "./Tree";

export class TreeHub {
  public static treeId: number = 0;
  public static edgeId: number = 0;

  public static edges: Map<number, Edge> = new Map<number, Edge>();

  public static components: Map<Component, Edge> = new Map<Component, Edge>();

  public static createTree(view: View | null = null): Tree {
    let elementEdge: Edge | null = null;

    if (view !== null) {
      const componentId = this.getComponentId(view);

      if (componentId === null) {
        throw new Error("View component is not mounted.");
      }

      const componentEdge = this.edges.get(componentId)!;

      elementEdge = componentEdge.children[0]!;
    }

    return new Tree(this.treeId++, elementEdge);
  }

  public static getComponentId(component: Component): number | null {
    return this.components.get(component)?.id ?? null;
  }
}
