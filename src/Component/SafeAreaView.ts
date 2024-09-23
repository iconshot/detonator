import $ from "untrue";

import { ViewProps } from "./View";

type SafeAreaEdge = "left" | "top" | "right" | "bottom";

interface SafeAreaViewProps extends ViewProps {
  edges: SafeAreaEdge[];
}

export function SafeAreaView({ children, ...attributes }: SafeAreaViewProps) {
  return $("com.iconshot.detonator.safeareaview", attributes, children);
}
