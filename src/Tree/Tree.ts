import {
  Slot,
  Ref,
  Hookster,
  ClassComponent,
  FunctionComponent,
  Comparer,
} from "untrue";

import { Detonator } from "../Detonator";

import { ErrorHandler } from "../ErrorHandler";

import { StyleSheetHelper } from "../StyleSheet/StyleSheetHelper";

import { HandlerManager } from "../Manager/HandlerManager";

import { Edge } from "./Edge";
import { Target } from "./Target";

import { TreeHub } from "./TreeHub";

interface SanitizedEdge {
  id: number;
  parent: number | null;
  contentType: string | null;
  attributes: string | null;
  children: SanitizedEdge[];
  text: string | null;
  skipped: boolean;
  moved: boolean;
}

export class Tree {
  private element: Element;

  private edge: Edge | null = null;

  private stack: Edge[] = [];

  private timeout: number | undefined;

  private deinitialized: boolean = false;

  private skippedIds: Set<number> = new Set();
  private movedIds: Set<number> = new Set();

  constructor(private treeId: number, elementEdge: Edge | null) {
    this.element = elementEdge?.element! ?? document.createElement("root");

    const elementId = elementEdge?.id ?? null;

    Detonator.send("com.iconshot.detonator.renderer/treeInit", {
      treeId,
      elementId,
    });
  }

  public deinit(): void {
    if (this.deinitialized) {
      return;
    }

    this.unmount();

    this.deinitialized = true;

    Detonator.send("com.iconshot.detonator.renderer/treeDeinit", {
      treeId: this.treeId,
    });
  }

  public mount(slot: Slot): void {
    if (this.deinitialized) {
      return;
    }

    if (this.edge !== null) {
      this.unmount();
    }

    const target = new Target(this.element);

    this.edge = new Edge(TreeHub.edgeId++, slot);

    this.renderEdge(this.edge, null, target);

    const sanitizedEdge = this.sanitizeEdge(this.edge);

    Detonator.send("com.iconshot.detonator.renderer/mount", {
      treeId: this.treeId,
      edge: sanitizedEdge,
    });
  }

  public unmount(): void {
    if (this.deinitialized) {
      return;
    }

    if (this.edge === null) {
      return;
    }

    const target = new Target(this.element);

    this.unmountEdge(this.edge, target);

    this.edge = null;

    this.stack = [];

    clearTimeout(this.timeout);

    Detonator.send("com.iconshot.detonator.renderer/unmount", {
      treeId: this.treeId,
    });
  }

  private renderChildren(
    edge: Edge,
    prevEdge: Edge | null,
    target: Target
  ): void {
    const children: Edge[] = [];
    const prevChildren: (Edge | null)[] = [];

    const toMoveChildren: Edge[] = [];

    const slot: Slot = edge.slot;

    const slots = slot.getChildren();

    const prevSlots = prevEdge?.children.map((child): any => child.slot) ?? [];

    for (let i = 0; i < slots.length; i++) {
      const slot = slots[i];

      let child: Edge | null = null;
      let prevChild: Edge | null = null;

      if (slot instanceof Slot && slot.getKey() !== null) {
        // set child as equal previous child (based on type and key)

        for (let j = 0; j < prevSlots.length; j++) {
          const prevSlot = prevSlots[j];

          const equal = this.compareSlots(slot, prevSlot);

          if (equal) {
            child = prevEdge!.children[j];

            if (j !== i) {
              toMoveChildren.push(child);
            }

            break;
          }
        }
      } else if (i < prevSlots.length) {
        // set child as same index previous child (only if they're equal)

        const prevSlot = prevSlots[i];

        const equal = this.compareSlots(slot, prevSlot);

        if (equal) {
          child = prevEdge!.children[i];
        }
      }

      // prepare child

      if (child === null) {
        child = new Edge(TreeHub.edgeId++, slot, edge.depth + 1, edge);
      } else {
        prevChild = child.clone();

        child.slot = slot;
      }

      children.push(child);
      prevChildren.push(prevChild);
    }

    edge.children = children;

    // unmount loop

    if (prevEdge !== null) {
      for (const prevChild of prevEdge.children) {
        const shouldBeUnmounted = !children.includes(prevChild);

        if (shouldBeUnmounted) {
          this.unmountEdge(prevChild, target);
        }
      }
    }

    // render loop

    for (let i = 0; i < children.length; i++) {
      const child = children[i];
      const prevChild = prevChildren[i];

      const shouldBeMoved = toMoveChildren.includes(child);

      if (shouldBeMoved) {
        const tmpTarget = new Target(target.element, target.index);

        this.moveEdge(child, tmpTarget);

        this.movedIds.add(child.id);
      }

      this.renderEdge(child, prevChild, target);
    }
  }

  private moveEdge(edge: Edge, target: Target): void {
    const element = edge.element;
    const children = edge.children;

    if (element !== null) {
      target.insert(element);

      return;
    }

    for (const child of children) {
      this.moveEdge(child, target);
    }
  }

  private renderEdge(edge: Edge, prevEdge: Edge | null, target: Target): void {
    const id = edge.id;
    const slot = edge.slot;
    const component = edge.component;
    const hookster = edge.hookster;

    TreeHub.edges.set(id, edge);

    if (component !== null) {
      this.unqueue(edge);
    }

    if (hookster !== null) {
      this.unqueue(edge);
    }

    if (prevEdge !== null) {
      const equal = this.compareEdges(edge, prevEdge);

      if (equal) {
        target.index += edge.targetNodesCount;

        this.skippedIds.add(id);

        return;
      }
    }

    const initialTargetIndex = target.index;

    try {
      if (slot instanceof Slot) {
        if (slot.isClass()) {
          this.renderClass(edge, prevEdge, target);
        } else if (slot.isFunction()) {
          this.renderFunction(edge, prevEdge, target);
        } else if (slot.isElement()) {
          this.renderElement(edge, prevEdge, target);
        } else if (slot.isNull()) {
          this.renderNull(edge, prevEdge, target);
        }
      } else if (slot !== null && slot !== undefined && slot !== false) {
        this.renderText(edge, prevEdge, target);
      }

      const targetNodesCount = target.index - initialTargetIndex;

      edge.targetNodesCount = targetNodesCount;
    } catch (error) {
      target.index += edge.targetNodesCount;

      ErrorHandler.handle(error);
    }
  }

  private renderClass(edge: Edge, prevEdge: Edge | null, target: Target): void {
    const slot: Slot = edge.slot;

    const prevSlot: Slot | null = prevEdge?.slot ?? null;

    const contentType = slot.getContentType();
    const props = slot.getProps();

    let component = edge.component;

    if (component === null) {
      const ComponentClass = contentType as ClassComponent;

      component = new ComponentClass(props);

      component.initialize((): void => {
        this.queue(edge);
      });
    } else {
      component.updateProps(props);
    }

    edge.component = component;

    TreeHub.components.set(component, edge);

    const ref = slot.getRef();

    const prevRef = prevSlot?.getRef() ?? null;

    if (prevRef instanceof Ref && prevRef !== ref) {
      prevRef.value = null;
    }

    if (ref instanceof Ref && ref !== prevRef) {
      ref.value = component;
    }

    const children = component.render() ?? [];

    slot.setChildren(children);

    this.renderChildren(edge, prevEdge, target);

    component.finishRender();
  }

  private renderFunction(
    edge: Edge,
    prevEdge: Edge | null,
    target: Target
  ): void {
    const slot: Slot = edge.slot;

    const prevSlot: Slot | null = prevEdge?.slot ?? null;

    const contentType = slot.getContentType();
    const props = slot.getProps();

    let hookster = edge.hookster;

    if (hookster === null) {
      hookster = new Hookster();

      hookster.initialize((): void => {
        this.queue(edge);
      });
    } else {
      hookster.performUpdate();
    }

    edge.hookster = hookster;

    hookster.activate();

    const prevProps = prevSlot?.getProps() ?? null;

    const ComponentFunction = contentType as FunctionComponent;

    const children = ComponentFunction(props, prevProps) ?? [];

    hookster.deactivate();

    slot.setChildren(children);

    this.renderChildren(edge, prevEdge, target);

    hookster.finishRender();
  }

  private renderElement(
    edge: Edge,
    prevEdge: Edge | null,
    target: Target
  ): void {
    let element = edge.element;

    if (element === null) {
      element = this.createElement(edge);
    }

    edge.element = element;

    this.patchElement(edge, prevEdge);

    const tmpTarget = new Target(element);

    this.renderChildren(edge, prevEdge, tmpTarget);

    target.insert(element);
  }

  private renderText(edge: Edge, prevEdge: Edge | null, target: Target): void {}

  private renderNull(edge: Edge, prevEdge: Edge | null, target: Target): void {
    this.renderChildren(edge, prevEdge, target);
  }

  private unmountEdge(edge: Edge, target: Target): void {
    const id = edge.id;
    const slot = edge.slot;
    const element = edge.element;
    const component = edge.component;
    const hookster = edge.hookster;
    const children = edge.children;

    TreeHub.edges.delete(id);

    let tmpTarget = target;

    if (element !== null) {
      target.remove(element);

      if (slot instanceof Slot && slot.isElement()) {
        tmpTarget = new Target(element);
      }
    }

    const ref = slot instanceof Slot ? slot.getRef() : null;

    if (ref instanceof Ref) {
      ref.value = null;
    }

    for (const child of children) {
      this.unmountEdge(child, tmpTarget);
    }

    if (component !== null) {
      TreeHub.components.delete(component);

      this.unqueue(edge);

      component.finishUnmount();
    }

    if (hookster !== null) {
      this.unqueue(edge);

      hookster.finishUnmount();
    }
  }

  //  check slots based on contentType and key

  private compareSlots(slot: any, prevSlot: any): boolean {
    if (slot instanceof Slot) {
      if (!(prevSlot instanceof Slot)) {
        return false;
      }

      const contentType = slot.getContentType();
      const key = slot.getKey();

      const prevContentType = prevSlot.getContentType();
      const prevKey = prevSlot.getKey();

      return contentType === prevContentType && key === prevKey;
    }

    // null, undefined and false are special cases since they will be ignored by renderEdge

    if (slot === null || slot === undefined || slot === false) {
      return prevSlot === null || prevSlot === undefined || prevSlot === false;
    }

    // check if both slots are texts

    return (
      prevSlot !== null &&
      prevSlot !== undefined &&
      prevSlot !== false &&
      !(prevSlot instanceof Slot)
    );
  }

  // check edges in case they may be skipped

  private compareEdges(edge: Edge, prevEdge: Edge): boolean {
    if (edge.slot instanceof Slot) {
      const slot: Slot = edge.slot;
      const prevSlot: Slot = prevEdge.slot;

      let equal = true;

      if (slot.isClass()) {
        equal = !edge.component!.needsUpdate();
      }

      if (slot.isFunction()) {
        equal = !edge.hookster!.needsUpdate();
      }

      if (equal) {
        equal = Comparer.compare(slot, prevSlot);
      }

      return equal;
    }

    return edge.slot === prevEdge.slot;
  }

  private createElement(edge: Edge): Element {
    const slot: Slot = edge.slot;

    const contentType = slot.getContentType();

    const tagName = contentType as string;

    return document.createElement(tagName);
  }

  private patchElement(edge: Edge, prevEdge: Edge | null): void {
    const slot: Slot = edge.slot;
    const element = edge.element!;

    const prevSlot: Slot | null = prevEdge?.slot ?? null;

    const attributes = slot.getAttributes() ?? {};

    const prevAttributes = prevSlot?.getAttributes() ?? {};

    for (const key in attributes) {
      const isHandlerName = HandlerManager.isHandlerName(key);

      if (!isHandlerName) {
        continue;
      }

      const value = attributes[key] ?? null;
      const prevValue = prevAttributes[key] ?? null;

      const isValueHandler = typeof value === "function";
      const isPrevValueHandler = typeof prevValue === "function";

      const eventName = HandlerManager.getEventName(key);

      if (value !== null) {
        if (isValueHandler && value !== prevValue) {
          if (prevValue !== null && isPrevValueHandler) {
            element.removeEventListener(eventName, prevValue);
          }

          element.addEventListener(eventName, value);
        }
      } else {
        if (prevValue !== null && isPrevValueHandler) {
          element.removeEventListener(eventName, prevValue);
        }
      }
    }

    for (const key in prevAttributes) {
      const found = key in attributes;

      if (found) {
        continue;
      }

      const isHandlerName = HandlerManager.isHandlerName(key);

      if (!isHandlerName) {
        continue;
      }

      const prevValue = prevAttributes[key];

      const isPrevValueHandler = typeof prevValue === "function";

      const eventName = HandlerManager.getEventName(key);

      if (prevValue !== null && isPrevValueHandler) {
        element.removeEventListener(eventName, prevValue);
      }
    }
  }

  private queue(edge: Edge): void {
    this.stack.push(edge);

    clearTimeout(this.timeout);

    this.timeout = setTimeout((): void => {
      this.rerender();
    });
  }

  private unqueue(edge: Edge): void {
    this.stack = this.stack.filter((tmpEdge): boolean => tmpEdge !== edge);
  }

  private rerender(): void {
    const sanitizedEdges: SanitizedEdge[] = [];

    this.stack.sort((a, b): number => a.depth - b.depth);

    while (this.stack.length > 0) {
      const edge = this.stack[0];

      const target = this.createTarget(edge);

      const prevEdge = edge.clone();

      this.renderEdge(edge, prevEdge, target);

      const difference = edge.targetNodesCount - prevEdge.targetNodesCount;

      if (difference !== 0) {
        this.propagateTargetNodesCountDifference(edge, difference);
      }

      const sanitizedEdge = this.sanitizeEdge(edge);

      sanitizedEdges.push(sanitizedEdge);
    }

    Detonator.send("com.iconshot.detonator.renderer/rerender", {
      treeId: this.treeId,
      edges: sanitizedEdges,
    });

    this.skippedIds.clear();
    this.movedIds.clear();
  }

  private createTarget(edge: Edge, targetIndex: number = 0): Target {
    const parent = edge.parent;

    if (parent === null) {
      return new Target(this.element, targetIndex);
    }

    const element = parent.element;
    const children = parent.children;

    const index = children.indexOf(edge);

    for (let i = index - 1; i >= 0; i--) {
      const child = children[i];

      targetIndex += child.targetNodesCount;
    }

    if (element !== null) {
      return new Target(element, targetIndex);
    }

    return this.createTarget(parent, targetIndex);
  }

  private propagateTargetNodesCountDifference(
    edge: Edge,
    difference: number
  ): void {
    const parent = edge.parent;

    if (parent === null) {
      return;
    }

    const element = parent.element;

    if (element !== null) {
      return;
    }

    parent.targetNodesCount += difference;

    this.propagateTargetNodesCountDifference(parent, difference);
  }

  private sanitizeEdge(
    edge: Edge,
    sanitizedParent: SanitizedEdge | null = null
  ): SanitizedEdge {
    const id = edge.id;
    const slot = edge.slot;
    const children = edge.children;

    let sanitizedEdge: SanitizedEdge | null = null;

    if (slot instanceof Slot) {
      if (slot.isClass()) {
        sanitizedEdge = this.sanitizeGeneric(edge);
      } else if (slot.isFunction()) {
        sanitizedEdge = this.sanitizeGeneric(edge);
      } else if (slot.isElement()) {
        sanitizedEdge = this.sanitizeElement(edge);
      } else if (slot.isNull()) {
        sanitizedEdge = this.sanitizeGeneric(edge);
      }
    } else if (slot !== null && slot !== undefined && slot !== false) {
      sanitizedEdge = this.sanitizeText(edge);
    } else {
      sanitizedEdge = this.sanitizeGeneric(edge);
    }

    sanitizedEdge = sanitizedEdge!;

    const skipped = this.skippedIds.has(id);
    const moved = this.movedIds.has(id);

    sanitizedEdge.skipped = skipped;
    sanitizedEdge.moved = moved;

    if (!skipped) {
      for (const child of children) {
        this.sanitizeEdge(child, sanitizedEdge);
      }
    }

    if (sanitizedParent !== null) {
      sanitizedParent.children.push(sanitizedEdge);
    }

    return sanitizedEdge;
  }

  private sanitizeGeneric(edge: Edge): SanitizedEdge {
    const id = edge.id;

    const parent = edge.parent?.id ?? null;

    return this.sanitizeSlot({ id, parent });
  }

  private sanitizeElement(edge: Edge): SanitizedEdge {
    const id = edge.id;
    const slot: Slot = edge.slot;

    const parent = edge.parent?.id ?? null;

    const contentType = slot.getContentType() as string;

    const attributes = slot.getAttributes();

    let sanitizedContentType: string | null = null;
    let sanitizedAttributes: string | null = null;

    const skipped = this.skippedIds.has(id);

    if (!skipped) {
      const tmpAttributes = {};

      for (const key in attributes) {
        const value = attributes[key] ?? null;

        switch (key) {
          case "key":
          case "ref": {
            break;
          }

          case "style": {
            const style = value;

            if (style === null) {
              tmpAttributes[key] = null;
            } else {
              const styles = StyleSheetHelper.combineStyles(style);

              tmpAttributes[key] = styles;
            }

            break;
          }

          default: {
            const isValueHandler = typeof value === "function";

            if (isValueHandler) {
              tmpAttributes[key] = true;
            } else {
              tmpAttributes[key] = value;
            }
          }
        }
      }

      sanitizedContentType = contentType;

      sanitizedAttributes = JSON.stringify(tmpAttributes);
    }

    return this.sanitizeSlot({
      id,
      parent,
      contentType: sanitizedContentType,
      attributes: sanitizedAttributes,
    });
  }

  private sanitizeText(edge: Edge): SanitizedEdge {
    const id = edge.id;
    const slot = edge.slot;

    const parent = edge.parent?.id ?? null;

    const skipped = this.skippedIds.has(id);

    let sanitizedText: string | null = null;

    if (!skipped) {
      sanitizedText = `${slot}`;
    }

    return this.sanitizeSlot({ id, parent, text: sanitizedText });
  }

  private sanitizeSlot({
    id,
    parent,
    contentType = null,
    attributes = null,
    children = [],
    text = null,
  }: {
    id: SanitizedEdge["id"];
    parent: SanitizedEdge["parent"];
  } & Partial<
    Omit<SanitizedEdge, "id" | "parent" | "skipped" | "moved">
  >): SanitizedEdge {
    const skipped = this.skippedIds.has(id);

    let sanitizedParent: number | null = null;

    if (!skipped) {
      sanitizedParent = parent;
    }

    return {
      id,
      parent: sanitizedParent,
      contentType,
      attributes,
      children,
      text,
      skipped: false,
      moved: false,
    };
  }
}
