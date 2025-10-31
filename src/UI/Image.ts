import $ from "untrue";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

export interface ImageLoadEvent extends Event {}

export interface ImageErrorEvent extends Event {}

interface ImageProps extends ViewProps {
  source?: string | null;
  onLoad?: ((event: ImageLoadEvent) => void) | null;
  onError?: ((event: ImageErrorEvent) => void) | null;
}

export class Image extends BaseView<ImageProps> {
  public render(): any {
    const { children, ...attributes } = this.props;

    return $("com.iconshot.detonator.ui.image", attributes, children);
  }
}
