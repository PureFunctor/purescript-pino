"use strict";

const pino = require("pino");

exports._mkLogger = function(options) {
  return function() {
    return pino(options);
  };
};
