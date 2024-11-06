import { Emitter } from "untrue";

import { EventManager } from "../Manager/EventManager";

export type AppStateState = "background" | "foreground" | "active";

type AppStateModuleSignatures = {
  state: (currentState: AppStateState) => any;
};

class AppStateModule extends Emitter<AppStateModuleSignatures> {
  public currentState: AppStateState | null = null;

  constructor() {
    super();

    EventManager.bind("com.iconshot.detonator.appstate/state", this);

    this.on("state", (currentState: AppStateState): void => {
      this.currentState = currentState;
    });
  }
}

export const AppState = new AppStateModule();
