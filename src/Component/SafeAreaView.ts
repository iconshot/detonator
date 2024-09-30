import $ from "untrue";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

type SafeAreaEdge = "left" | "top" | "right" | "bottom";

interface SafeAreaViewProps extends ViewProps {
  edges: SafeAreaEdge[];
}

export class SafeAreaView extends BaseView<SafeAreaViewProps> {
  render() {
    const { children, ...attributes } = this.props;

    return $("com.iconshot.detonator.safeareaview", attributes, children);
  }
}
