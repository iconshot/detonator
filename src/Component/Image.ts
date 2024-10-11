import $ from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

export interface ImageLoadEvent extends Event {}

export interface ImageErrorEvent extends Event {}

interface ImageProps extends ViewProps {
  url?: string | null;
  onLoad?: ((event: ImageLoadEvent) => void) | null;
  onError?: ((event: ImageErrorEvent) => void) | null;
}

export class Image extends BaseView<ImageProps> {
  public render(): any {
    const { children, ...attributes } = this.props;

    return $("com.iconshot.detonator.image", attributes, children);
  }

  public static async getSize(
    url: string
  ): Promise<{ width: number; height: number }> {
    return await Detonator.request({
      name: "com.iconshot.detonator.image/getSize",
      data: url,
    });
  }
}
