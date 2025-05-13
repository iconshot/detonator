import $, { PropsNoChildren, Ref } from "untrue";

import { Style, StyleColor } from "../StyleSheet/StyleSheet";

import { BaseView } from "./BaseView";

import { View, ViewProps } from "./View";

interface ActivityIndicatorProps extends ViewProps {
  color: StyleColor;
  size?: "medium" | "large" | null;
}

export class ActivityIndicator extends BaseView<ActivityIndicatorProps> {
  private viewRef: Ref<View> = new Ref();

  public style(style: Style): void {
    const view = this.viewRef.value!;

    view.style(style);
  }

  public render(): any {
    const { size, color, children, ...attributes } = this.props;

    const tmpAttributes: Omit<
      PropsNoChildren<ActivityIndicatorProps>,
      "color"
    > = {
      style: { color },
      size,
    };

    return $(
      View,
      { ref: this.viewRef, ...attributes },
      $("com.iconshot.detonator.activityindicator", tmpAttributes)
    );
  }
}
