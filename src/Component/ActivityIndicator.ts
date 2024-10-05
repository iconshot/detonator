import $, { Ref } from "untrue";

import { BaseView } from "./BaseView";

import { Style, StyleColor, View, ViewProps } from "./View";

interface ActivityIndicatorProps extends ViewProps {
  color: StyleColor;
  size?: "medium" | "large" | null;
}

export class ActivityIndicator extends BaseView<ActivityIndicatorProps> {
  private viewRef: Ref<View> = new Ref();

  public style(style: Style): void {
    const view = this.viewRef.current!;

    view.style(style);
  }

  public render(): any {
    const { size, color, children, ...attributes } = this.props;

    const tmpAttributes: any = { size, style: { color } };

    return $(
      View,
      { ref: this.viewRef, ...attributes },
      $("com.iconshot.detonator.activityindicator", tmpAttributes)
    );
  }
}
