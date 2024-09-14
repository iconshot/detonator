import $ from "untrue";

import { BaseView } from "./BaseView";

export class Text extends BaseView {
  public render(): any {
    const { children, ...attributes } = this.props;

    return $("com.iconshot.detonator.text", attributes, children);
  }
}
