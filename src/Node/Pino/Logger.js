"use strict";

const pino = require("pino");

exports._mkLogger = function(options) {
  return function() {
    return pino(options);
  };
};

exports._logImpl = function(level, logger, options) {
  return function() {
    return logger[level](...options);
  };
};
