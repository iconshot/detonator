import { Detonator } from "../Detonator";

export class Storage {
  private name: string;

  constructor(name: string | null = null) {
    this.name = name ?? "com.iconshot.detonator.storage";
  }

  async getItem(key: string): Promise<string | null> {
    const name = this.name;

    return await Detonator.request({
      name: "com.iconshot.detonator.storage/getItem",
      data: { name, key },
    });
  }

  async setItem(key: string, value: string): Promise<void> {
    const name = this.name;

    await Detonator.request({
      name: "com.iconshot.detonator.storage/setItem",
      data: { name, key, value },
    });
  }
}
