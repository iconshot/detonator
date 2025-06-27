import $, { PropsNoChildren } from "untrue";

import { Detonator } from "../Detonator";

import { BaseView } from "./BaseView";

import { ViewProps } from "./View";

export interface AudioReadyEvent extends Event {}

export interface AudioPlayEvent extends Event {}

export interface AudioPauseEvent extends Event {}

export interface AudioSeekEvent extends Event {
  position: number;
}

export interface AudioProgressEvent extends Event {
  position: number;
}

export interface AudioEndEvent extends Event {}

interface AudioProps extends ViewProps {
  source?: string | null;
  muted?: boolean | null;
  onReady?: ((event: AudioReadyEvent) => void) | null;
  onPlay?: ((event: AudioPlayEvent) => void) | null;
  onPause?: ((event: AudioPauseEvent) => void) | null;
  onSeek?: ((event: AudioSeekEvent) => void) | null;
  onProgress?: ((event: AudioProgressEvent) => void) | null;
  onEnd?: ((event: AudioEndEvent) => void) | null;
}

export class Audio extends BaseView<AudioProps> {
  public position: number = 0;

  public async play(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.audio::play" },
      this
    );
  }

  public async pause(): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.audio::pause" },
      this
    );
  }

  public async seek(position: number): Promise<void> {
    await Detonator.request(
      { name: "com.iconshot.detonator.audio::seek", data: position },
      this
    );
  }

  private onProgress = (event: AudioProgressEvent): void => {
    const { onProgress = null } = this.props;

    this.position = event.position;

    if (onProgress !== null) {
      onProgress(event);
    }
  };

  public render(): any {
    const { children, ...attributes } = this.props;

    const tmpAttributes: PropsNoChildren<AudioProps> = {
      ...attributes,
      onProgress: this.onProgress,
    };

    return $("com.iconshot.detonator.audio", tmpAttributes, children);
  }
}
