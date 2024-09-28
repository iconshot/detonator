import $ from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { StyleColor, ViewProps } from "./View";

interface InputChangeEvent extends Event {
  value: string;
}

interface InputNextEvent extends Event {}

interface InputProps extends ViewProps {
  placeholder?: string | number | null;
  placeholderColor?: StyleColor | null;
  value?: string | null;
  inputType?: "text" | "password" | "email" | null;
  onChange?: ((event: InputChangeEvent) => void) | null;
  onDone?: ((event: InputNextEvent) => void) | null;
}

export class Input extends BaseView<InputProps> {
  public value: string = "";

  public init(): void {
    const { value } = this.props;

    this.value = value ?? "";
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

  public render(): any {
    const {
      children,
      onChange: tmpOnChange = null,
      ...tmpAttributes
    } = this.props;

    const onChange = (event: InputChangeEvent) => {
      this.value = event.value;

      if (tmpOnChange !== null) {
        tmpOnChange(event);
      }
    };

    const attributes = { ...tmpAttributes, onChange };

    return $("com.iconshot.detonator.input", attributes, children);
  }
}
