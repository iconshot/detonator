#!/usr/bin/env node

const args = process.argv.slice(2);

const init = require("./init");
const start = require("./start");

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
}
