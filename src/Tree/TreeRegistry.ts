import { Component } from "untrue";

import { Edge } from "./Edge";

export class TreeRegistry {
  public static treeId: number = 0;
  public static edgeId: number = 0;

  public static edges: Map<number, Edge> = new Map<number, Edge>();

  public static components: Map<Component, Edge> = new Map();
  public static elements: Map<Element, Edge> = new Map();

  public static rootElement: Element = document.createElement("root");
}
