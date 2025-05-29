import { Emitter, Hook } from "untrue";

import { Detonator } from "../Detonator";

export type AppStateState = "background" | "foreground" | "active";

type AppStateModuleSignatures = {
  state: () => any;
};

class AppStateModule extends Emitter<AppStateModuleSignatures> {
  public state: AppStateState | null = null;

  constructor() {
    super();

    Detonator.emitter.on(
      "com.iconshot.detonator.appstate.state",
      (state: AppStateState): void => {
        this.state = state;

        this.emit("state");
      }
    );
  }

  public useAppState(): AppStateState | null {
    const update = Hook.useUpdate();

    Hook.useMountEffect((): (() => void) => {
      this.on("state", update);

      return (): void => {
        this.off("state", update);
      };
    });

    return this.state;
  }
}

export const AppState = new AppStateModule();
