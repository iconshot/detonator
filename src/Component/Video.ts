import $ from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

export interface VideoPlayEvent extends Event {}

export interface VideoPauseEvent extends Event {}

export interface VideoSeekEvent extends Event {
  ms: number;
}

interface VideoProps extends ViewProps {
  url?: string | null;
  onPlay?: ((event: VideoPlayEvent) => void) | null;
  onPause?: ((event: VideoPauseEvent) => void) | null;
  onSeek?: ((event: VideoSeekEvent) => void) | null;
}

export class Video extends BaseView<VideoProps> {
  public async play(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.video/play" },
      this
    );
  }

  public async pause(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.video/pause" },
      this
    );
  }

  public async seek(ms: number): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.video/seek", data: ms },
      this
    );
  }

  public render(): any {
    const { children, ...attributes } = this.props;

    return $("com.iconshot.detonator.video", attributes, children);
  }
}
