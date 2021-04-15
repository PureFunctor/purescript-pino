module Test.Main where

import Prelude

import Effect (Effect)
import Foreign.Object as FO
import Node.Pino.Logger (defaultLogger, info)


main :: Effect Unit
main = do
  logger <- defaultLogger
  void $ info logger "This is doing some info debugging"
  void $ info logger "Templates work too! %s" "Like this!"

  void $ info logger "Passing `mergingObject` works as such:"
  void $ info logger (FO.empty # FO.insert "merging" "object")
