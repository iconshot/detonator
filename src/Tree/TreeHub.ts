import { Component } from "untrue";

import { View } from "../Component/View";

import { Edge } from "./Edge";
import { Tree } from "./Tree";

export class TreeHub {
  static treeId: number = 0;
  static edgeId: number = 0;

  static edges: Map<number, Edge> = new Map<number, Edge>();

  static components: Map<Component, Edge> = new Map<Component, Edge>();

  static createTree(view: View | null = null): Tree {
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

  static getComponentId(component: Component): number | null {
    return this.components.get(component)?.id ?? null;
  }
}
