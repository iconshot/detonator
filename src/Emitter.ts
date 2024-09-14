import { Emitter } from "untrue";

type WindowEmitterSignatures = {
  handler: (json: string) => any;
  event: (json: string) => any;
  response: (json: string) => any;
};

export const WindowEmitter = new Emitter<WindowEmitterSignatures>();

const windowAny = window as any;

windowAny.emitter = WindowEmitter;
