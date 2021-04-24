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
