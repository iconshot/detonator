import $ from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { StyleColor, ViewProps } from "./View";

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
  public value: string = "";

  public init(): void {
    const { value } = this.props;

    this.value = value ?? "";
  }

  public async setValue(value: string): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.textarea/setValue", data: value },
      this
    );
  }

  public async focus(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.textarea/focus" },
      this
    );
  }

  public async blur(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.textarea/blur" },
      this
    );
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

    const tmpAttributes = { ...attributes, onChange: this.onChange };

    return $("com.iconshot.detonator.textarea", tmpAttributes, children);
  }
}
