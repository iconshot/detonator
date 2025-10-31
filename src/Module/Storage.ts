import { Detonator } from "../Detonator";

export class Storage {
  private name: string;

  constructor(name: string | null = null) {
    this.name = name ?? "com.iconshot.detonator.storage";
  }

  public async getItem(key: string): Promise<string | null> {
    const value = await Detonator.request(
      "com.iconshot.detonator.storage::getItem",
      {
        name: this.name,
        key,
      }
    ).fetch();

    if (value === ":n") {
      return null;
    }

    return value.slice(1);
  }

  public async setItem(key: string, value: string): Promise<void> {
    await Detonator.request("com.iconshot.detonator.storage::setItem", {
      name: this.name,
      key,
      value,
    }).fetch();
  }
}
