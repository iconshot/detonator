import { Detonator } from "../Detonator";

export class FileReadStream {
  private static ID: number = 0;

  private id: number = FileReadStream.ID++;

  private offset: number = 0;

  constructor(
    private readonly path: string,
    private readonly size: number = 1024 * 1024 // default size is 1 MB
  ) {}

  public read(): Promise<Uint8Array> {
    return new Promise<Uint8Array>((resolve, reject): void => {
      const dataListener = (value: string): boolean => {
        const [idString, data] = value.split("\n", 2);

        const id = parseInt(idString);

        if (id !== this.id) {
          return true;
        }

        const binary = atob(data);

        const bytes = new Uint8Array(binary.length);

        for (let i = 0; i < binary.length; i++) {
          bytes[i] = binary.charCodeAt(i);
        }

        this.offset += bytes.length;

        resolve(bytes);

        cleanUp();

        return false;
      };

      const errorListener = (value: string): boolean => {
        const [idString, errorMessage] = value.split("\n", 2);

        const id = parseInt(idString);

        if (id !== this.id) {
          return true;
        }

        const error = new Error(errorMessage);

        reject(error);

        cleanUp();

        return false;
      };

      const cleanUp = (): void => {
        Detonator.emitter.off(
          "com.iconshot.detonator.filestream.read.data",
          dataListener
        );

        Detonator.emitter.off(
          "com.iconshot.detonator.filestream.read.error",
          errorListener
        );
      };

      Detonator.emitter.on(
        "com.iconshot.detonator.filestream.read.data",
        dataListener
      );

      Detonator.emitter.on(
        "com.iconshot.detonator.filestream.read.error",
        errorListener
      );

      Detonator.send("com.iconshot.detonator.filestream.read::run", {
        id: this.id,
        path: this.path,
        offset: this.offset,
        size: this.size,
      });
    });
  }
}
