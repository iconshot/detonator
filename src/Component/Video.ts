import $, { PropsNoChildren } from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

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
  onPlay?: ((event: VideoPlayEvent) => void) | null;
  onPause?: ((event: VideoPauseEvent) => void) | null;
  onSeek?: ((event: VideoSeekEvent) => void) | null;
  onProgress?: ((event: VideoProgressEvent) => void) | null;
  onEnd?: ((event: VideoEndEvent) => void) | null;
}

export class Video extends BaseView<VideoProps> {
  public position: number = 0;

  public async play(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.video::play" },
      this
    );
  }

  public async pause(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.video::pause" },
      this
    );
  }

  public async seek(position: number): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.video::seek", data: position },
      this
    );
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

    const tmpAttributes: PropsNoChildren<VideoProps> = {
      ...attributes,
      onProgress: this.onProgress,
    };

    return $("com.iconshot.detonator.video", tmpAttributes, children);
  }
}
