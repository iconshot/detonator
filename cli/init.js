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

module.exports = async () => {
  const templateDir = path.resolve(__dirname, "../template");

  const currentDir = process.cwd();

  const name = path.basename(currentDir);

  console.log(`Initializing project "${name}"`);

  await fse.copy(templateDir, currentDir);

  const replaceObject = {
    HelloWorldApp: name,
    "com.example.helloworldapp": `com.example.${name.toLowerCase()}`,
  };

  await replacePath(currentDir, replaceObject);

  const packagePath = path.resolve(__dirname, "../package.json");

  const package = require(packagePath);

  const currentPackagePath = path.resolve(currentDir, "package.json");

  const packageReplaceObject = { "{{ version }}": package.version };

  await replacePath(currentPackagePath, packageReplaceObject);

  console.log("Installing dependencies");

  await exec("npm i");

  console.log("\x1b[32m%s\x1b[0m", "\u2713 Finished. Happy coding!");
};
