# purescript-pino
PureScript bindings for [pino](https://github.com/pinojs/pino).

## Requirements
This package requires `pino` to be added as a dependency for your project.

## Overview
This package provides a low-level foreign API for using [pino](https://github.com/pinojs/pino) loggers in PureScript. It provides a set of logging functions that emulate rest parameters through type class magic. Take for example:
```purescript
main :: Effect Unit
main = do
  logger <- defaultLogger
  void $ info logger "This is doing some info debugging"
  void $ info logger "Templates work too! %s" "Like this!"
  
  void $ info logger "Passing `mergingObject` works as such:"
  void $ info logger (FO.empty # FO.insert "merging" "object")
```
