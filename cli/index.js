#!/usr/bin/env node

const args = process.argv.slice(2);

const init = require("./init");
const start = require("./start");
const build = require("./build");

const command = args[0];

switch (command) {
  case "init": {
    init();

    break;
  }

  case "start": {
    start();

    break;
  }

  case "build": {
    build();

    break;
  }
}
