module Node.Pino
  ( module Node.Pino.Logger
  , module Data.Function
  , module Data.Options
  , module Foreign
  , module Foreign.Object
  ) where

import Data.Function ((#))
import Data.Options ((:=))
import Foreign (Foreign, unsafeToForeign)
import Foreign.Object (Object, empty, insert)
import Node.Pino.Logger hiding (_logImpl, _mkLogger)
