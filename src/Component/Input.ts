import $, { PropsNoChildren } from "untrue";

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
  public value: string = "";

  public init(): void {
    const { value } = this.props;

    this.value = value ?? "";
  }

  public async setValue(value: string): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.input/setValue", data: value },
      this
    );
  }

  public async focus(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.input/focus" },
      this
    );
  }

  public async blur(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.input/blur" },
      this
    );
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

    const tmpAttributes: PropsNoChildren<InputProps> = {
      ...attributes,
      onChange: this.onChange,
    };

    return $("com.iconshot.detonator.input", tmpAttributes, children);
  }
}
