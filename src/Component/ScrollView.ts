import $ from "untrue";

import { BaseView } from "./BaseView";

import { Style, View, ViewProps } from "./View";

interface ScrollViewPageChangeEvent extends Event {
  page: number;
}

interface ScrollViewProps extends ViewProps {
  style: Style;
  contentContainerStyle?: Style | null;
  horizontal?: boolean | null;
  paginated?: boolean | null;
  showsIndicator?: boolean | null;
  onPageChange?: ((event: ScrollViewPageChangeEvent) => void) | null;
}

export class ScrollView extends BaseView<ScrollViewProps> {
  public render(): any {
    const { style, contentContainerStyle, children, ...attributes } =
      this.props;

    let tmpStyle: Style = { ...style };

    tmpStyle.padding = null;
    tmpStyle.paddingHorizontal = null;
    tmpStyle.paddingVertical = null;
    tmpStyle.paddingTop = null;
    tmpStyle.paddingLeft = null;
    tmpStyle.paddingBottom = null;
    tmpStyle.paddingRight = null;

    const horizontal = attributes.horizontal ?? false;

    const tmpAttributes = { ...attributes, style: tmpStyle, horizontal };

    let tmpContentContainerStyle = contentContainerStyle ?? {};

    tmpContentContainerStyle.flexDirection = horizontal ? "row" : "column";

    return $(
      horizontal
        ? "com.iconshot.detonator.horizontalscrollview"
        : "com.iconshot.detonator.verticalscrollview",
      tmpAttributes,
      $(View, { style: tmpContentContainerStyle }, children)
    );
  }
}
