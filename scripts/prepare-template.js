const fsp = require("node:fs/promises");
const path = require("node:path");

const fse = require("fs-extra");

const package = require("../package.json");

async function replaceIosPbxproj() {
  const filePath = path.resolve(
    __dirname,
    "../template/ios/HelloWorldApp.xcodeproj/project.pbxproj"
  );

  const content = await fsp.readFile(filePath, "utf8");

  const lines = content.split("\n");

  const filteredLines = lines.filter(
    (line) => !line.includes("DEVELOPMENT_TEAM")
  );

  const tmpContent = filteredLines.join("\n");

  await fsp.writeFile(filePath, tmpContent, "utf8");
}

async function replacePackageJson() {
  const filePath = path.resolve(__dirname, "../template/package.json");

  const json = await fse.readJson(filePath);

  json.dependencies.detonator = package.version;

  await fse.writeJson(filePath, json, { spaces: 2 });
}

replaceIosPbxproj();
replacePackageJson();
