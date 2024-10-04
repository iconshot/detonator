import $ from "untrue";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

interface IconProps extends ViewProps {
  name: string;
}

export class Icon extends BaseView<IconProps> {
  render() {
    const { children, ...attributes } = this.props;

    return $("com.iconshot.detonator.icon", attributes);
  }
}
