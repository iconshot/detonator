import { Emitter } from "untrue";

import { Detonator } from "./Detonator";

export class ErrorHandler {
  static handle(error: any): void {
    Detonator.log(`[ErrorHandler] ${error.message}`);
  }
}

Emitter.onError = (error): void => {
  ErrorHandler.handle(error);
};
