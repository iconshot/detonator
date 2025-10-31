import $, { Ref } from "untrue";

import { Detonator } from "../Detonator";

import { StyleColor } from "../StyleSheet/StyleSheet";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

export interface InputChangeEvent extends Event {
  value: string;
}

export interface InputNextEvent extends Event {}

interface InputProps extends ViewProps {
  placeholder?: string | number | null;
  placeholderColor?: StyleColor | null;
  value?: string | null;
  inputType?: "text" | "password" | "email" | null;
  autoCapitalize?: "characters" | "words" | "sentences" | "none" | null;
  onChange?: ((event: InputChangeEvent) => void) | null;
  onDone?: ((event: InputNextEvent) => void) | null;
}

export class Input extends BaseView<InputProps> {
  private elementRef: Ref<Element> = new Ref();

  public value: string = "";

  public init(): void {
    const { value } = this.props;

    this.value = value ?? "";
  }

  public async setValue(value: string): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("Input element is not mounted.");
    }

    await Detonator.request("com.iconshot.detonator.ui.input::setValue", value)
      .withEdge(element)
      .fetch();
  }

  public async focus(): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("Input element is not mounted.");
    }

    await Detonator.request("com.iconshot.detonator.ui.input::focus")
      .withEdge(element)
      .fetch();
  }

  public async blur(): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("Input element is not mounted.");
    }

    await Detonator.request("com.iconshot.detonator.ui.input::blur")
      .withEdge(element)
      .fetch();
  }

  private onChange = (event: InputChangeEvent): void => {
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

    return $("com.iconshot.detonator.ui.input", tmpAttributes, children);
  }
}
