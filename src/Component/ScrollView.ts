import $ from "untrue";

import { BaseView } from "./BaseView";

import { Style, View, ViewProps } from "./View";

interface ScrollViewProps extends ViewProps {
  contentContainerStyle?: Style | null;
  horizontal?: boolean | null;
  showsIndicator?: boolean | null;
}

export class ScrollView extends BaseView<ScrollViewProps> {
  public render(): any {
    const { contentContainerStyle, children, ...attributes } = this.props;

    return $(
      "com.iconshot.detonator.scrollview",
      attributes,
      $(View, { style: contentContainerStyle }, children)
    );
  }
}
