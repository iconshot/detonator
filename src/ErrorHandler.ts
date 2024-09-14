import { Emitter } from "untrue";

import { Messenger } from "./Messenger";

export class ErrorHandler {
  static handle(error: any): void {
    Messenger.log(`[ErrorHandler] ${error.message}`);
  }
}

Emitter.onError = (error): void => {
  ErrorHandler.handle(error);
};
