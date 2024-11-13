import { Emitter, Hook } from "untrue";

import { EventManager } from "../Manager/EventManager";

export type AppStateState = "background" | "foreground" | "active";

type AppStateModuleSignatures = {
  state: (state: AppStateState) => any;
};

class AppStateModule extends Emitter<AppStateModuleSignatures> {
  public state: AppStateState | null = null;

  constructor() {
    super();

    EventManager.bind("com.iconshot.detonator.appstate/state", this);

    this.on("state", (state: AppStateState): void => {
      this.state = state;
    });
  }

  public useAppState(): AppStateState | null {
    const update = Hook.useUpdate();

    Hook.useEffect((): (() => void) => {
      this.on("state", update);

      return () => {
        this.off("state", update);
      };
    }, []);

    return this.state;
  }
}

export const AppState = new AppStateModule();
