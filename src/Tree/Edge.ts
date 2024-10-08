import { Component, Hookster } from "untrue";

export class Edge {
  constructor(
    public readonly slot: any,
    public readonly parent: Edge | null = null,
    public readonly depth: number = 0,
    public children: Edge[] = [],
    public component: Component | null = null,
    public hookster: Hookster | null = null,
    public id: number | null = null,
    public element: Element | null = null
  ) {}

  clone(): Edge {
    return new Edge(
      this.slot,
      this.parent,
      this.depth,
      this.children,
      this.component,
      this.hookster,
      this.id,
      this.element
    );
  }
}
