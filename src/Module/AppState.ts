import { Emitter } from "untrue";

import { EventManager } from "../Manager/EventManager";

type AppStateModuleSignatures = {
  state: (currentState: string) => any;
};

class AppStateModule extends Emitter<AppStateModuleSignatures> {
  currentState: string | null = null;

  constructor() {
    super();

    EventManager.bind("com.iconshot.detonator.appstate/state", this);

    this.on("state", (currentState: string): void => {
      this.currentState = currentState;
    });
  }
}

export const AppState = new AppStateModule();
