import $ from "untrue";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

interface TextProps extends ViewProps {
  maxLines?: number | null;
}

export class Text extends BaseView<TextProps> {
  public render(): any {
    const { children, ...attributes } = this.props;

    return $("com.iconshot.detonator.text", attributes, children);
  }
}
