import { Emitter } from "untrue";

import { Detonator } from "../Detonator";

export class EventManager {
  public static bind(name: string, emitter: Emitter): void {
    Detonator.on("event", (json: string): void => {
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
