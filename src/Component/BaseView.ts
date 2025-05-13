import { Component } from "untrue";

import { Style } from "../StyleSheet/StyleSheet";

import { StyleSheetApplyStyleHelper } from "../StyleSheet/StyleSheetApplyStyleHelper";

import { StyleSheetRemoveStyleHelper } from "../StyleSheet/StyleSheetRemoveStyleHelper";

import { ViewProps } from "./View";

export class BaseView<K extends ViewProps = ViewProps> extends Component<K> {
  public style(style: Style): void {
    StyleSheetApplyStyleHelper.applyStyle(this, style);
  }

  public removeStyle<K extends keyof Style>(key: K | K[] | null = null): void {
    StyleSheetRemoveStyleHelper.removeStyle(this, key);
  }
}
