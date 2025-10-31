import { Detonator } from "../Detonator";

export class FileReadStream {
  private static ID: number = 0;

  private id: number = FileReadStream.ID++;

  private offset: number = 0;

  constructor(
    private readonly path: string,
    private readonly size: number = 1024 * 1024 // default size is 1 MB
  ) {}

  public async read(): Promise<Uint8Array> {
    const base64 = await Detonator.request(
      "com.iconshot.detonator.filestream::read",
      { id: this.id, path: this.path, offset: this.offset, size: this.size }
    ).fetch();

    const binary = atob(base64);

    const bytes = new Uint8Array(binary.length);

    for (let i = 0; i < binary.length; i++) {
      bytes[i] = binary.charCodeAt(i);
    }

    this.offset += bytes.length;

    return bytes;
  }
}
