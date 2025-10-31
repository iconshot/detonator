import $, { Ref } from "untrue";

import { Detonator } from "../Detonator";

import { StyleColor } from "../StyleSheet/StyleSheet";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

export interface TextAreaChangeEvent extends Event {
  value: string;
}

interface TextAreaProps extends ViewProps {
  placeholder?: string | number | null;
  placeholderColor?: StyleColor | null;
  value?: string | null;
  autoCapitalize?: "characters" | "words" | "sentences" | "none" | null;
  onChange?: ((event: TextAreaChangeEvent) => void) | null;
}

export class TextArea extends BaseView<TextAreaProps> {
  private elementRef: Ref<Element> = new Ref();

  public value: string = "";

  public init(): void {
    const { value } = this.props;

    this.value = value ?? "";
  }

  public async setValue(value: string): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("TextArea element is not mounted.");
    }

    await Detonator.request(
      "com.iconshot.detonator.ui.textarea::setValue",
      value
    )
      .withEdge(element)
      .fetch();
  }

  public async focus(): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("TextArea element is not mounted.");
    }

    await Detonator.request("com.iconshot.detonator.ui.textarea::focus")
      .withEdge(element)
      .fetch();
  }

  public async blur(): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("TextArea element is not mounted.");
    }

    await Detonator.request("com.iconshot.detonator.ui.textarea::blur")
      .withEdge(element)
      .fetch();
  }

  private onChange = (event: TextAreaChangeEvent): void => {
    const { onChange = null } = this.props;

    this.value = event.value;

    if (onChange !== null) {
      onChange(event);
    }
  };

  public render(): any {
    const { children, ...attributes } = this.props;

    const tmpAttributes = {
      ref: this.elementRef,
      ...attributes,
      onChange: this.onChange,
    };

    return $("com.iconshot.detonator.ui.textarea", tmpAttributes, children);
  }
}
