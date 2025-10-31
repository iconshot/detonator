export class MessageFormatter {
  private static delimiter = "\x00";

  public static join(lines: any[]): string {
    return lines
      .map((line): string => {
        if (typeof line === "string") {
          return line;
        } else if (line === undefined) {
          return "";
        } else {
          return JSON.stringify(line);
        }
      })
      .join(this.delimiter);
  }

  public static split(value: string, limit: number = 0): string[] {
    const parts = value.split(this.delimiter);

    if (limit === 0) {
      return parts;
    }

    if (parts.length <= limit) {
      return parts;
    }

    const head = parts.slice(0, limit - 1);
    const tail = parts.slice(limit - 1).join(this.delimiter);

    return [...head, tail];
  }
}
