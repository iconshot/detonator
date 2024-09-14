import $, { Props } from "untrue";

type SafeAreaEdge = "left" | "top" | "right" | "bottom";

interface SafeAreaViewProps extends Props {
  edges: SafeAreaEdge[];
}

export function SafeAreaView({ children, ...attributes }: SafeAreaViewProps) {
  return $("com.iconshot.detonator.safeareaview", attributes);
}
