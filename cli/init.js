const path = require("node:path");
const fsp = require("node:fs/promises");
const util = require("node:util");

const exec = util.promisify(require("node:child_process").exec);

const fse = require("fs-extra");

async function replacePath(targetPath, object) {
  const stat = await fsp.stat(targetPath);

  if (stat.isFile()) {
    let content = await fsp.readFile(targetPath, "utf8");

    for (const key in object) {
      const value = object[key];

      content = content.replace(new RegExp(key, "g"), value);
    }

    await fsp.writeFile(targetPath, content, "utf8");
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

  const dirname = path.dirname(targetPath);
  const basename = path.basename(targetPath);

  let finalTargetPath = targetPath;

  let finalBasename = basename;

  for (const key in object) {
    const value = object[key];

    finalBasename = finalBasename.replace(key, value);
  }

  if (finalBasename !== basename) {
    finalTargetPath = path.resolve(dirname, finalBasename);

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

module.exports = async () => {
  const templateDir = path.resolve(__dirname, "../template");

  const currentDir = process.cwd();

  const name = path.basename(currentDir);

  {
    console.log(`Initializing project "${name}"`);

    await fse.copy(templateDir, currentDir);

    const androidPath = path.resolve(currentDir, "android");
    const iosPath = path.resolve(currentDir, "ios");

    const replaceObject = { HelloWorldApp: name };

    const androidReplaceObject = {
      ...replaceObject,
      "com.example.helloworldapp": `com.example.${name.toLowerCase()}`,
    };

    const iosReplaceObject = {
      ...replaceObject,
      "com.example.HelloWorldApp": `com.example.${name}`,
    };

    await replacePath(androidPath, androidReplaceObject);
    await replacePath(iosPath, iosReplaceObject);

    const androidRenameObject = { helloworldapp: name.toLowerCase() };

    const iosRenameObject = { HelloWorldApp: name };

    await renamePath(androidPath, androidRenameObject);
    await renamePath(iosPath, iosRenameObject);

    const libraryPackagePath = path.resolve(__dirname, "../package.json");

    const package = require(libraryPackagePath);

    const packagePath = path.resolve(currentDir, "package.json");

    const packageReplaceObject = {
      ...replaceObject,
      "{{ version }}": package.version,
    };

    await replacePath(packagePath, packageReplaceObject);
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
};
