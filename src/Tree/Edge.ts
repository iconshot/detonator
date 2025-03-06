import { Component, Hookster } from "untrue";

export class Edge {
  constructor(
    public id: number,
    public slot: any,
    public depth: number = 0,
    public parent: Edge | null = null,
    public children: Edge[] = [],
    public component: Component | null = null,
    public hookster: Hookster | null = null,
    public element: Element | null = null,
    public targetNodesCount: number = 0
  ) {}

  public clone(): Edge {
    return new Edge(
      this.id,
      this.slot,
      this.depth,
      this.parent,
      this.children,
      this.component,
      this.hookster,
      this.element,
      this.targetNodesCount
    );
  }
}
