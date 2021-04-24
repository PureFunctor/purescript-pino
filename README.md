# purescript-pino
PureScript bindings for [pino](https://github.com/pinojs/pino).

## Requirements
This package requires `pino` to be added as a dependency for your project.

## Overview
This package provides a low-level foreign API for using [pino](https://github.com/pinojs/pino)
loggers in PureScript. It provides a set of logging functions that emulate rest parameters through
type class magic. Take for example:
```purescript
module Test.Main where

import Prelude

import Effect (Effect)
import Foreign.Object as FO
import Node.Pino.Logger (defaultLogger, info, runLogger)
import Node.Pino.Logger.Do as Pino


main :: Effect Unit
main = do
  logger <- defaultLogger
  runLogger logger Pino.do
    info "This is doing some info debugging"
    info "Templates work too! %s" "Like this!"

    info "Passing `mergingObject` works as such:"
    info (FO.empty # FO.insert "merging" "object")
```
Note: The `Node.Logger` module provides essential re-exports for `Data.Options` and extra ones for
working with `Foreign` and `Foreign.Object`. However, I still highly recommend using qualified
imports for the latter, similar to the code snippet above for brevity. 
