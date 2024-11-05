import $ from "untrue";

import { BaseView } from "./BaseView";

import { Style, View, ViewProps } from "./View";

export interface ScrollViewPageChangeEvent extends Event {
  page: number;
}

interface ScrollViewProps extends ViewProps {
  style: Style;
  contentContainerStyle?: Style | null;
  horizontal?: boolean | null;
  paginated?: boolean | null;
  inverted?: boolean | null;
  showsIndicator?: boolean | null;
  onPageChange?: ((event: ScrollViewPageChangeEvent) => void) | null;
}

export class ScrollView extends BaseView<ScrollViewProps> {
  public render(): any {
    const {
      style,
      contentContainerStyle = null,
      children,
      ...attributes
    } = this.props;

    const tmpStyle: Style = { ...style };

    tmpStyle.padding = null;
    tmpStyle.paddingHorizontal = null;
    tmpStyle.paddingVertical = null;
    tmpStyle.paddingTop = null;
    tmpStyle.paddingLeft = null;
    tmpStyle.paddingBottom = null;
    tmpStyle.paddingRight = null;

    const horizontal = attributes.horizontal ?? false;
    const inverted = attributes.inverted ?? false;

    const tmpAttributes = {
      ...attributes,
      style: tmpStyle,
      horizontal,
      inverted,
    };

    const tmpContentContainerStyle = { ...(contentContainerStyle ?? {}) };

    tmpContentContainerStyle.flexDirection = horizontal
      ? inverted
        ? "row-reverse"
        : "row"
      : inverted
      ? "column-reverse"
      : "column";

    return $(
      horizontal
        ? "com.iconshot.detonator.horizontalscrollview"
        : "com.iconshot.detonator.verticalscrollview",
      tmpAttributes,
      $(View, { style: tmpContentContainerStyle }, children)
    );
  }
}
