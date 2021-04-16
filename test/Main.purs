module Test.Main where

import Prelude

import Effect (Effect)
import Foreign.Object as FO
import Node.Pino.Logger (defaultLogger, info, runLogger)


main :: Effect Unit
main = do
  logger <- defaultLogger
  runLogger logger do
    void $ info "This is doing some info debugging"
    void $ info "Templates work too! %s" "Like this!"

    void $ info "Passing `mergingObject` works as such:"
    void $ info (FO.empty # FO.insert "merging" "object")
