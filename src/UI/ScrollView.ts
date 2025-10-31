import $, { PropsNoChildren } from "untrue";

import { StyleSheet } from "../StyleSheet/StyleSheet";

import { BaseView } from "./BaseView";

import { StyleAttribute, View, ViewProps } from "./View";

const styles = StyleSheet.create({
  contentContainerHorizontal: { flexDirection: "row" },
  contentContainerHorizontalInverted: { flexDirection: "row-reverse" },
  contentContainerVertical: { flexDirection: "column" },
  contentContainerVerticalInverted: { flexDirection: "column-reverse" },
});

export interface ScrollViewPageChangeEvent extends Event {
  page: number;
}

interface ScrollViewProps extends ViewProps {
  contentContainerStyle?: StyleAttribute | null;
  horizontal?: boolean | null;
  paginated?: boolean | null;
  inverted?: boolean | null;
  showsIndicator?: boolean | null;
  onPageChange?: ((event: ScrollViewPageChangeEvent) => void) | null;
}

export class ScrollView extends BaseView<ScrollViewProps> {
  public render(): any {
    const {
      contentContainerStyle = null,
      children,
      ...attributes
    } = this.props;

    const horizontal = attributes.horizontal ?? false;
    const inverted = attributes.inverted ?? false;

    const contentContainerStyles: StyleAttribute = [];

    contentContainerStyles.push(contentContainerStyle);

    if (horizontal) {
      contentContainerStyles.push(
        inverted
          ? styles.contentContainerHorizontalInverted
          : styles.contentContainerHorizontal
      );
    } else {
      contentContainerStyles.push(
        inverted
          ? styles.contentContainerVerticalInverted
          : styles.contentContainerVertical
      );
    }

    const tmpAttributes: Omit<
      PropsNoChildren<ScrollViewProps>,
      "contentContainerStyle"
    > = { ...attributes, horizontal, inverted };

    return $(
      horizontal
        ? "com.iconshot.detonator.ui.horizontalscrollview"
        : "com.iconshot.detonator.ui.verticalscrollview",
      tmpAttributes,
      $(View, { style: contentContainerStyles }, children)
    );
  }
}
