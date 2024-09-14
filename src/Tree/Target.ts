export class Target {
  constructor(public readonly element: Element, public index: number = 0) {}

  insert(child: Node): void {
    const currentChild: Node | null =
      this.index < this.element.childNodes.length
        ? this.element.childNodes[this.index]
        : null;

    if (currentChild !== null) {
      if (child !== currentChild) {
        this.element.insertBefore(child, currentChild);
      }
    } else {
      this.element.appendChild(child);
    }

    this.index++;
  }

  remove(child: Node): void {
    this.element.removeChild(child);
  }
}
