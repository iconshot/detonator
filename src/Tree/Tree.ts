import { Slot, Ref, Hookster, ClassComponent, FunctionComponent } from "untrue";

import { Messenger } from "../Messenger";

import { ErrorHandler } from "../ErrorHandler";

import { HandlerManager } from "../Manager/HandlerManager";

import { Edge } from "./Edge";
import { StackItem } from "./StackItem";
import { Target } from "./Target";

import { TreeHub } from "./TreeHub";

interface SerializedEdge {
  id: number;
  parent: number | null;
  contentType: string | null;
  attributes: string | null;
  children: SerializedEdge[];
  text: string | null;
}

export class Tree {
  private element: Element;

  private edge: Edge | null = null;

  private stack: StackItem[] = [];

  private timeout: number | undefined;

  private deinitialized: boolean = false;

  constructor(private treeId: number, elementEdge: Edge | null) {
    this.element = elementEdge?.element! ?? document.createElement("root");

    const elementId = elementEdge?.id ?? null;

    Messenger.treeInit({ treeId, elementId });
  }

  public deinit(): void {
    if (this.deinitialized) {
      return;
    }

    this.unmount();

    this.deinitialized = true;

    Messenger.treeDeinit({ treeId: this.treeId });
  }

  public mount(slot: Slot): void {
    if (this.deinitialized) {
      return;
    }

    if (this.edge !== null) {
      this.unmount();
    }

    const target = new Target(this.element);

    this.edge = new Edge(slot);

    this.renderEdge(this.edge, null, target);

    const serializedEdge = this.serializeEdge(this.edge);

    Messenger.mount({ treeId: this.treeId, edge: serializedEdge });
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

    Messenger.unmount({ treeId: this.treeId });
  }

  private queue(edge: Edge, element: Element): void {
    const item = new StackItem(edge, element);

    this.stack.push(item);

    clearTimeout(this.timeout);

    this.timeout = setTimeout((): void => {
      this.rerender();
    });
  }

  private unqueue(edge: Edge): void {
    this.stack = this.stack.filter((item): boolean => {
      if (edge.component !== null) {
        return item.edge.component !== edge.component;
      }

      if (edge.hookster !== null) {
        return item.edge.hookster !== edge.hookster;
      }

      return true;
    });
  }

  private rerender(serializedEdges: SerializedEdge[] = []): void {
    if (this.stack.length === 0) {
      Messenger.rerender({ treeId: this.treeId, edges: serializedEdges });

      return;
    }

    this.stack.sort((a, b): number => a.edge.depth - b.edge.depth);

    const item = this.stack[0];

    const edge = item.edge;
    const element = item.element;

    const currentEdge = edge.clone();

    const index = this.findTargetIndex(edge, element);

    const target = new Target(element, index);

    this.renderEdge(edge, currentEdge, target);

    const serializedEdge = this.serializeEdge(edge);

    serializedEdges.push(serializedEdge);

    this.rerender(serializedEdges);
  }

  private createChildren(edge: Edge): void {
    const slot = edge.slot;

    const children = slot instanceof Slot ? slot.getChildren() : [];

    const edges = children.map(
      (child): Edge => new Edge(child, edge, edge.depth + 1)
    );

    edge.children = edges;
  }

  private renderChildren(
    edge: Edge,
    currentEdge: Edge | null,
    target: Target
  ): void {
    this.createChildren(edge);

    const children = edge.children;

    const currentChildren = currentEdge?.children ?? [];

    for (let i = 0; i < currentChildren.length; i++) {
      const currentChild = currentChildren[i];

      let child: Edge | null = null;

      const currentSlot = currentChild.slot;

      if (currentSlot instanceof Slot && currentSlot.getKey() !== null) {
        for (const tmpChild of children) {
          if (this.isEqual(currentChild, tmpChild)) {
            child = tmpChild;

            break;
          }
        }
      }

      if (child === null && i < children.length) {
        const tmpChild = children[i];

        if (this.isEqual(currentChild, tmpChild)) {
          child = tmpChild;
        }
      }

      if (child === null) {
        this.unmountEdge(currentChild, target);
      }
    }

    for (let i = 0; i < children.length; i++) {
      const child = children[i];

      let currentChild: Edge | null = null;

      const slot = child.slot;

      if (slot instanceof Slot && slot.getKey() !== null) {
        for (const tmpChild of currentChildren) {
          if (this.isEqual(child, tmpChild)) {
            currentChild = tmpChild;

            break;
          }
        }
      }

      if (currentChild === null && i < currentChildren.length) {
        const tmpChild = currentChildren[i];

        if (this.isEqual(child, tmpChild)) {
          currentChild = tmpChild;
        }
      }

      this.renderEdge(child, currentChild, target);
    }
  }

  private renderEdge(
    edge: Edge,
    currentEdge: Edge | null,
    target: Target
  ): void {
    const slot = edge.slot;

    if (currentEdge !== null) {
      edge.children = currentEdge.children;

      edge.id = currentEdge.id;
    } else {
      edge.id = TreeHub.edgeId++;
    }

    try {
      if (slot instanceof Slot) {
        if (slot.isComponent()) {
          this.renderComponent(edge, currentEdge, target);
        } else if (slot.isFunction()) {
          this.renderFunction(edge, currentEdge, target);
        } else if (slot.isElement()) {
          this.renderElement(edge, currentEdge, target);
        } else if (slot.isNull()) {
          this.renderNull(edge, currentEdge, target);
        }
      } else if (slot !== null && slot !== undefined && slot !== false) {
        this.renderText(edge, currentEdge, target);
      }
    } catch (error) {
      ErrorHandler.handle(error);
    }

    TreeHub.edges.set(edge.id!, edge);
  }

  private renderComponent(
    edge: Edge,
    currentEdge: Edge | null,
    target: Target
  ): void {
    const slot: Slot = edge.slot;

    const currentSlot: Slot | null = currentEdge?.slot ?? null;

    const contentType = slot.getContentType();
    const props = slot.getProps();

    let component = currentEdge?.component ?? null;

    if (component === null) {
      const ComponentClass = contentType as ClassComponent;

      component = new ComponentClass(props);

      component.init();
    } else {
      component.updateProps(props);
    }

    edge.component = component;

    TreeHub.components.set(component, edge);

    this.unqueue(edge);

    const ref = slot.getRef();

    const currentRef = currentSlot?.getRef() ?? null;

    if (currentRef instanceof Ref && currentRef !== ref) {
      currentRef.current = null;
    }

    if (ref instanceof Ref && ref !== currentRef) {
      ref.current = component;
    }

    const children = component.render();

    slot.setChildren(children);

    this.renderChildren(edge, currentEdge, target);

    queueMicrotask((): void => {
      component.triggerRender((): void => {
        this.queue(edge, target.element);
      });
    });
  }

  private renderFunction(
    edge: Edge,
    currentEdge: Edge | null,
    target: Target
  ): void {
    const slot: Slot = edge.slot;

    const contentType = slot.getContentType();
    const props = slot.getProps();

    let hookster = currentEdge?.hookster ?? null;

    if (hookster === null) {
      hookster = new Hookster();
    }

    edge.hookster = hookster;

    this.unqueue(edge);

    hookster.activate();

    const ComponentFunction = contentType as FunctionComponent;

    const children = ComponentFunction(props);

    hookster.deactivate();

    slot.setChildren(children);

    this.renderChildren(edge, currentEdge, target);

    queueMicrotask((): void => {
      hookster.hook((): void => {
        this.queue(edge, target.element);
      });
    });
  }

  private renderElement(
    edge: Edge,
    currentEdge: Edge | null,
    target: Target
  ): void {
    let element = currentEdge?.element ?? null;

    if (element === null) {
      element = this.createElement(edge);
    }

    edge.element = element;

    this.patchElement(edge, currentEdge);

    const tmpTarget = new Target(element);

    this.renderChildren(edge, currentEdge, tmpTarget);

    target.insert(element);
  }

  private renderText(
    edge: Edge,
    currentEdge: Edge | null,
    target: Target
  ): void {}

  private renderNull(
    edge: Edge,
    currentEdge: Edge | null,
    target: Target
  ): void {
    this.renderChildren(edge, currentEdge, target);
  }

  private unmountEdge(edge: Edge, target: Target): void {
    const slot = edge.slot;
    const element = edge.element;
    const component = edge.component;
    const hookster = edge.hookster;
    const children = edge.children;

    let tmpTarget = target;

    if (element !== null) {
      target.remove(element);

      if (slot instanceof Slot && slot.isElement()) {
        tmpTarget = new Target(element);
      }
    }

    const ref = slot instanceof Slot ? slot.getRef() : null;

    if (ref instanceof Ref) {
      ref.current = null;
    }

    for (const child of children) {
      this.unmountEdge(child, tmpTarget);
    }

    if (component !== null) {
      TreeHub.components.delete(component);

      this.unqueue(edge);

      queueMicrotask((): void => {
        component.triggerUnmount();
      });
    }

    if (hookster !== null) {
      this.unqueue(edge);

      queueMicrotask((): void => {
        hookster.unhook();
      });
    }

    TreeHub.edges.delete(edge.id!);
  }

  private isEqual(edge: Edge, currentEdge: Edge): boolean {
    const slot = edge.slot;
    const currentSlot = currentEdge.slot;

    if (slot instanceof Slot) {
      if (!(currentSlot instanceof Slot)) {
        return false;
      }

      const contentType = slot.getContentType();
      const key = slot.getKey();

      const currentContentType = currentSlot.getContentType();
      const currentKey = currentSlot.getKey();

      return contentType === currentContentType && key === currentKey;
    }

    if (slot === null || slot === undefined || slot === false) {
      return (
        currentSlot === null ||
        currentSlot === undefined ||
        currentSlot === false
      );
    }

    return (
      currentSlot !== null &&
      currentSlot !== undefined &&
      currentSlot !== false &&
      !(currentSlot instanceof Slot)
    );
  }

  private createElement(edge: Edge): Element {
    const slot = edge.slot as Slot;

    const contentType = slot.getContentType();

    const tagName = contentType as string;

    return document.createElement(tagName);
  }

  private patchElement(edge: Edge, currentEdge: Edge | null): void {
    const slot = edge.slot as Slot;
    const element = edge.element!;

    const currentSlot = (currentEdge?.slot ?? null) as Slot | null;

    const attributes = slot.getAttributes() ?? {};

    const currentAttributes = currentSlot?.getAttributes() ?? {};

    for (const key in attributes) {
      const isHandlerName = HandlerManager.isHandlerName(key);

      if (!isHandlerName) {
        continue;
      }

      const value = attributes[key] ?? null;
      const currentValue = currentAttributes[key] ?? null;

      const isValueHandler = typeof value === "function";
      const isCurrentValueHandler = typeof currentValue === "function";

      const eventName = HandlerManager.getEventName(key);

      if (value !== null) {
        if (isValueHandler && value !== currentValue) {
          if (currentValue !== null && isCurrentValueHandler) {
            element.removeEventListener(eventName, currentValue);
          }

          element.addEventListener(eventName, value);
        }
      } else {
        if (currentValue !== null && isCurrentValueHandler) {
          element.removeEventListener(eventName, currentValue);
        }
      }
    }

    for (const key in currentAttributes) {
      const found = key in attributes;

      if (found) {
        continue;
      }

      const isHandlerName = HandlerManager.isHandlerName(key);

      if (!isHandlerName) {
        continue;
      }

      const currentValue = currentAttributes[key];

      const isCurrentValueHandler = typeof currentValue === "function";

      const eventName = HandlerManager.getEventName(key);

      if (currentValue !== null && isCurrentValueHandler) {
        element.removeEventListener(eventName, currentValue);
      }
    }
  }

  private findTargetIndex(edge: Edge, targetElement: Element): number {
    const parent = edge.parent;

    if (parent === null) {
      return 0;
    }

    const element = parent.element;
    const children = parent.children;

    const index = children.indexOf(edge);

    for (let i = index - 1; i >= 0; i--) {
      const child = children[i];

      const j = this.findElementIndex(child, targetElement);

      if (j !== null) {
        return j + 1;
      }
    }

    if (element === targetElement) {
      return 0;
    }

    return this.findTargetIndex(parent, targetElement);
  }

  private findElementIndex(edge: Edge, targetElement: Element): number | null {
    const element = edge.element;
    const children = edge.children;

    if (element !== null) {
      const childNodes = [...targetElement.childNodes];

      return childNodes.indexOf(element as ChildNode);
    }

    for (let i = children.length - 1; i >= 0; i--) {
      const child = children[i];

      const index = this.findElementIndex(child, targetElement);

      if (index !== null) {
        return index;
      }
    }

    return null;
  }

  private serializeEdge(
    edge: Edge,
    parent: SerializedEdge | null = null
  ): SerializedEdge {
    const slot = edge.slot;
    const children = edge.children;

    let object: SerializedEdge | null = null;

    if (slot instanceof Slot) {
      if (slot.isComponent()) {
        object = this.serializeComponent(edge);
      } else if (slot.isFunction()) {
        object = this.serializeFunction(edge);
      } else if (slot.isElement()) {
        object = this.serializeElement(edge);
      } else if (slot.isNull()) {
        object = this.serializeNull(edge);
      }
    } else if (slot !== null && slot !== undefined && slot !== false) {
      object = this.serializeText(edge);
    } else {
      object = this.serializeEmpty(edge);
    }

    for (const child of children) {
      this.serializeEdge(child, object!);
    }

    if (parent !== null) {
      parent.children.push(object!);
    }

    return object!;
  }

  private serializeComponent(edge: Edge): SerializedEdge {
    const id = edge.id!;

    const parent = edge.parent?.id ?? null;

    return this.serializeSlot({ id, parent });
  }

  private serializeFunction(edge: Edge): SerializedEdge {
    const id = edge.id!;

    const parent = edge.parent?.id ?? null;

    return this.serializeSlot({ id, parent });
  }

  private serializeElement(edge: Edge): SerializedEdge {
    const id = edge.id!;
    const slot = edge.slot as Slot;

    const parent = edge.parent?.id ?? null;

    const contentType = slot.getContentType() as string;

    const { children, ...props } = slot.getProps();

    return this.serializeSlot({ id, parent, contentType, attributes: props });
  }

  private serializeText(edge: Edge): SerializedEdge {
    const id = edge.id!;
    const slot = edge.slot;

    const parent = edge.parent?.id ?? null;

    const text = `${slot}`;

    return this.serializeSlot({ id, parent, text });
  }

  private serializeNull(edge: Edge): SerializedEdge {
    const id = edge.id!;

    const parent = edge.parent?.id ?? null;

    return this.serializeSlot({ id, parent });
  }

  private serializeEmpty(edge: Edge): SerializedEdge {
    const id = edge.id!;

    const parent = edge.parent?.id ?? null;

    return this.serializeSlot({ id, parent });
  }

  private serializeSlot({
    id,
    parent,
    contentType = null,
    attributes = null,
    children = [],
    text = null,
  }: { id: SerializedEdge["id"]; parent: SerializedEdge["parent"] } & Partial<
    Omit<SerializedEdge, "id" | "attributes"> & {
      attributes: { [key: string]: any } | null;
    }
  >): SerializedEdge {
    let tmpAttributes: string | null = null;

    if (attributes !== null) {
      for (const key in attributes) {
        const value = attributes[key];

        if (typeof value === "function") {
          attributes[key] = true;
        }
      }

      tmpAttributes = JSON.stringify(attributes);
    }

    return {
      id,
      parent,
      contentType,
      attributes: tmpAttributes,
      children,
      text,
    };
  }
}
