import $ from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

interface OnSeekData {
  time: number;
}

interface VideoProps extends ViewProps {
  url?: string | null;
  onPlay?: () => void;
  onPause?: () => void;
  onSeek?: (data: OnSeekData) => void;
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
