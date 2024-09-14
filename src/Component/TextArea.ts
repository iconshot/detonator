import $ from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

interface TextAreaChangeEvent extends Event {
  value: string;
}

interface TextAreaProps extends ViewProps {
  placeholder?: string | number | null;
  value?: string | null;
  onChange?: ((event: TextAreaChangeEvent) => void) | null;
}

export class TextArea extends BaseView<TextAreaProps> {
  public value: string = "";

  public init(): void {
    const { value } = this.props;

    this.value = value ?? "";
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

  public render(): any {
    const {
      children,
      onChange: tmpOnChange = null,
      ...tmpAttributes
    } = this.props;

    const onChange = (event: TextAreaChangeEvent) => {
      this.value = event.value;

      if (tmpOnChange !== null) {
        tmpOnChange(event);
      }
    };

    const attributes = { ...tmpAttributes, onChange };

    return $("com.iconshot.detonator.textarea", attributes, children);
  }
}
