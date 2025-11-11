const path = require("node:path");
const fs = require("node:fs");

const { exec } = require("node:child_process");

module.exports = async (pipe = true) => {
  return new Promise((resolve, reject) => {
    const appConfigPath = path.resolve(process.cwd(), "webpack.config.js");

    const libraryConfigPath = path.resolve(
      __dirname,
      "../config/webpack.config.js"
    );

    const configPath = fs.existsSync(appConfigPath)
      ? appConfigPath
      : libraryConfigPath;

    const command = `npx webpack --config ${configPath} --color`;

    const webpackProcess = exec(command, (error) => {
      if (error !== null) {
        reject(error);

        return;
      }

      resolve();
    });

    if (pipe) {
      webpackProcess.stdout.pipe(process.stdout);
      webpackProcess.stderr.pipe(process.stderr);
    }
  });
};
