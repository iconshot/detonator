import { Emitter } from "untrue";

import { WindowEmitter } from "../Emitter";

export class EventManager {
  static bind(name: string, emitter: Emitter): void {
    WindowEmitter.on("event", (json: string): void => {
      const { name: eventName, data }: { name: string; data: any } =
        JSON.parse(json);

      if (eventName !== name) {
        return;
      }

      const tmpName = name.split("/").pop()!;

      emitter.emit(tmpName, data);
    });
  }
}
