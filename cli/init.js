const path = require("node:path");
const fsp = require("node:fs/promises");
const util = require("node:util");
const readline = require("node:readline");

const exec = util.promisify(require("node:child_process").exec);

const fse = require("fs-extra");

async function init(appName, appId) {
  {
    console.log(`Initializing project "${appName}"`);

    const currentDir = process.cwd();

    const templateDir = path.resolve(__dirname, "../template");

    await fse.copy(templateDir, currentDir);

    const replaceObject = { HelloWorldApp: appName };

    const packagePath = path.resolve(currentDir, "package.json");

    await replacePath(packagePath, replaceObject);

    const androidPath = path.resolve(currentDir, "android");
    const iosPath = path.resolve(currentDir, "ios");

    const androidReplaceObject = {
      "com.example.helloworldapp": appId,
      ...replaceObject,
    };

    const iosReplaceObject = {
      "com.example.HelloWorldApp": appId,
      ...replaceObject,
    };

    await replacePath(androidPath, androidReplaceObject);
    await replacePath(iosPath, iosReplaceObject);

    const androidRenameObject = {
      "com/example/helloworldapp": appId.replace(".", "/"),
    };

    const iosRenameObject = {
      HelloWorldApp: appName,
      "HelloWorldApp.xcodeproj": `${appName}.xcodeproj`,
    };

    await renamePath(androidPath, androidRenameObject);
    await renamePath(iosPath, iosRenameObject);
  }

  {
    console.log("Installing dependencies");

    await exec("npm i");
  }

  {
    console.log("Bundling");

    const libraryConfigPath = path.resolve(
      __dirname,
      "../config/webpack.config.js"
    );

    const command = `npx webpack --config ${libraryConfigPath}`;

    await exec(command);
  }

  console.log("\x1b[32m%s\x1b[0m", "\u2713 Finished. Happy coding!");
}

async function replacePath(targetPath, object) {
  const stat = await fsp.stat(targetPath);

  if (stat.isFile()) {
    const content = await fsp.readFile(targetPath, "utf8");

    let tmpContent = content;

    for (const key in object) {
      const value = object[key];

      tmpContent = tmpContent.replace(new RegExp(key, "g"), value);
    }

    if (content !== tmpContent) {
      await fsp.writeFile(targetPath, tmpContent, "utf8");
    }
  } else if (stat.isDirectory()) {
    const items = await fsp.readdir(targetPath);

    const promises = items.map((item) => {
      const tmpTargetPath = path.join(targetPath, item);

      return replacePath(tmpTargetPath, object);
    });

    await Promise.all(promises);
  }
}

async function renamePath(targetPath, object) {
  const stat = await fsp.stat(targetPath);

  let finalTargetPath = targetPath;

  for (const key in object) {
    const value = object[key];

    const regex = new RegExp(`${key}$`);

    finalTargetPath = finalTargetPath.replace(regex, value);
  }

  if (targetPath !== finalTargetPath) {
    await fsp.rename(targetPath, finalTargetPath);
  }

  if (stat.isDirectory()) {
    const items = await fsp.readdir(finalTargetPath);

    const promises = items.map((item) => {
      const tmpTargetPath = path.join(finalTargetPath, item);

      return renamePath(tmpTargetPath, object);
    });

    await Promise.all(promises);
  }
}

module.exports = () => {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  rl.question("App name: ", (appName) => {
    const appIdPlaceholder = `com.${appName.toLowerCase()}`;

    rl.question(`App id [${appIdPlaceholder}]: `, async (appIdValue) => {
      const appId = appIdValue.trim() || appIdPlaceholder;

      await init(appName, appId);

      rl.close();
    });
  });
};
