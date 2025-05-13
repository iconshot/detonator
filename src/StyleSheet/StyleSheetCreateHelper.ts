import { Detonator } from "../Detonator";

import { StyleEntry } from "./StyleSheetHelper";

interface IdStyleEntry {
  id: number;
  styleEntry: StyleEntry;
}

export class StyleSheetCreateHelper {
  public static styleEntryId: number = 0;

  public static styleEntries: Map<number, StyleEntry> = new Map();

  public static send(): void {
    if (this.styleEntries.size === 0) {
      return;
    }

    const idStyleEntries: IdStyleEntry[] = [];

    this.styleEntries.forEach((styleEntry, styleEntryId) => {
      const idStyleEntry: IdStyleEntry = { id: styleEntryId, styleEntry };

      idStyleEntries.push(idStyleEntry);
    });

    this.styleEntries.clear();

    Detonator.send("com.iconshot.detonator.stylesheet/create", idStyleEntries);
  }
}
