import $, { Props } from "untrue";

import { BaseView } from "./BaseView";

import { Style } from "../StyleSheet/StyleSheet";

export interface ViewTapEvent extends Event {}

export interface ViewLongTapEvent extends Event {}

export interface ViewDoubleTapEvent extends Event {}

export type StyleAttribute =
  | number
  | Style
  | null
  | undefined
  | StyleAttribute[];

export interface ViewProps extends Props {
  style?: StyleAttribute;
  onTap?: ((event: ViewTapEvent) => void) | null;
  onLongTap?: ((event: ViewLongTapEvent) => void) | null;
  onDoubleTap?: ((event: ViewDoubleTapEvent) => void) | null;
}

export class View extends BaseView {
  private __brand: "View";

  public render(): any {
    const { children, ...attributes } = this.props;

    return $("com.iconshot.detonator.view", attributes, children);
  }
}
