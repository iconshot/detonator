const path = require("node:path");
const fsp = require("node:fs/promises");

class CopyPlugin {
  constructor(dirs) {
    this.dirs = dirs;
  }

  apply(compiler) {
    compiler.hooks.afterEmit.tapAsync(
      "CopyPlugin",
      async (compilation, callback) => {
        const dir = compilation.options.output.path;
        const filename = "index.js";

        const src = path.resolve(dir, filename);

        const destPaths = this.dirs.map((dir) => path.resolve(dir, filename));

        const promises = destPaths.map(async (dest) => {
          const dir = path.dirname(dest);

          await fsp.mkdir(dir, { recursive: true });

          await fsp.copyFile(src, dest);
        });

        await Promise.all(promises);

        callback();
      }
    );
  }
}

const appTsConfigPath = path.resolve(process.cwd(), "tsconfig.json");

const packagePath = path.resolve(process.cwd(), "package.json");

const packageJson = require(packagePath);

const appName = packageJson.name;

const copyDirs = [
  `android/${appName}/app/src/main/assets/dist`,
  `ios/${appName}/${appName}/Resources/dist`,
].map((dir) => path.resolve(process.cwd(), dir));

module.exports = {
  entry: path.resolve(process.cwd(), "src/index"),
  output: {
    path: path.resolve(process.cwd(), "dist/esm"),
    filename: "index.js",
  },
  module: {
    rules: [
      {
        test: /\.ts?$/,
        use: [
          {
            loader: "ts-loader",
            options: { configFile: appTsConfigPath, transpileOnly: true },
          },
        ],
        exclude: /node_modules/,
      },
      {
        test: /\.js$/,
        resolve: { fullySpecified: false },
      },
    ],
  },
  resolve: { extensions: [".ts", ".js"] },
  plugins: [new CopyPlugin(copyDirs)],
};
