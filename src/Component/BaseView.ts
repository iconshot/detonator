import { Component } from "untrue";

import { Detonator } from "../Detonator";

import { ViewProps, Style } from "./View";

export class BaseView<K extends ViewProps = ViewProps> extends Component<K> {
  public style(style: Style): void {
    Detonator.style(this, style);
  }
}
