import $, { Ref } from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

export interface VideoReadyEvent extends Event {}

export interface VideoPlayEvent extends Event {}

export interface VideoPauseEvent extends Event {}

export interface VideoSeekEvent extends Event {
  position: number;
}

export interface VideoProgressEvent extends Event {
  position: number;
}

export interface VideoEndEvent extends Event {}

interface VideoProps extends ViewProps {
  source?: string | null;
  muted?: boolean | null;
  onReady?: ((event: VideoReadyEvent) => void) | null;
  onPlay?: ((event: VideoPlayEvent) => void) | null;
  onPause?: ((event: VideoPauseEvent) => void) | null;
  onSeek?: ((event: VideoSeekEvent) => void) | null;
  onProgress?: ((event: VideoProgressEvent) => void) | null;
  onEnd?: ((event: VideoEndEvent) => void) | null;
}

export class Video extends BaseView<VideoProps> {
  private elementRef: Ref<Element> = new Ref();

  public position: number = 0;

  public async play(): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("Video element is not mounted.");
    }

    await Detonator.request("com.iconshot.detonator.ui.video::play")
      .withEdge(element)
      .fetch();
  }

  public async pause(): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("Video element is not mounted.");
    }

    await Detonator.request("com.iconshot.detonator.ui.video::pause")
      .withEdge(element)
      .fetch();
  }

  public async seek(position: number): Promise<void> {
    const element = this.elementRef.value;

    if (element === null) {
      throw new Error("Video element is not mounted.");
    }

    await Detonator.request("com.iconshot.detonator.ui.video::seek", position)
      .withEdge(element)
      .fetch();
  }

  private onProgress = (event: VideoProgressEvent): void => {
    const { onProgress = null } = this.props;

    this.position = event.position;

    if (onProgress !== null) {
      onProgress(event);
    }
  };

  public render(): any {
    const { children, ...attributes } = this.props;

    const tmpAttributes = {
      ref: this.elementRef,
      ...attributes,
      onProgress: this.onProgress,
    };

    return $("com.iconshot.detonator.ui.video", tmpAttributes, children);
  }
}
