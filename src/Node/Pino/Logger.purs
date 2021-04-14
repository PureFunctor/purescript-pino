module Node.Pino.Logger where

import Prelude

import Data.Function.Uncurried (Fn3, runFn3)
import Data.Options (Option, Options(..), opt, options)
import Effect (Effect)
import Foreign (Foreign, unsafeToForeign)
import Foreign.Object (Object)
import Unsafe.Coerce (unsafeCoerce)


data LoggerOptions

name :: Option LoggerOptions String
name = opt "name"

level :: Option LoggerOptions String
level = opt "level"

customLevels :: Option LoggerOptions ( Object Int )
customLevels = opt "customLevels"

useOnlyCustomLevels :: Option LoggerOptions Boolean
useOnlyCustomLevels = opt "useOnlyCustomLevels"

mixin :: Option LoggerOptions Foreign
mixin = opt "mixin"

redact :: Option LoggerOptions Foreign
redact = opt "redact"

hooks :: Option LoggerOptions ( Object Foreign )
hooks = opt "hooks"

formatters :: Option LoggerOptions ( Object Foreign )
formatters = opt "formatters"

serializers :: Option LoggerOptions ( Object Foreign )
serializers = opt "serializers"

base :: Option LoggerOptions ( Object Foreign )
base = opt "base"

enabled :: Option LoggerOptions Boolean
enabled = opt "enabled"

crlf :: Option LoggerOptions Boolean
crlf = opt "crlf"

timestamp :: Option LoggerOptions Foreign
timestamp = opt "timestamp"

messageKey :: Option LoggerOptions Foreign
messageKey = opt "messageKey"

nestedKey :: Option LoggerOptions Foreign
nestedKey = opt "nestedKey"

prettyPrint :: Option LoggerOptions Foreign
prettyPrint = opt "prettyPrint"

destination :: Option LoggerOptions Foreign
destination = opt "destination"

defaultLoggerOptions :: Options LoggerOptions
defaultLoggerOptions = Options [ ]

foreign import data Logger :: Type

foreign import _mkLogger :: Foreign -> Effect Logger

mkLogger :: Options LoggerOptions -> Effect Logger
mkLogger = _mkLogger <<< options

defaultLogger :: Effect Logger
defaultLogger = mkLogger defaultLoggerOptions

foreign import _logImpl :: Fn3 String Logger ( Array Foreign ) ( Effect Unit )

class LogImpl n where
  logImpl :: String -> Logger -> ( Array Foreign ) -> n

instance logImplBase :: LogImpl ( Effect r ) where
  logImpl = unsafeCoerce $ runFn3 _logImpl

else instance logImplP :: LogImpl n => LogImpl ( f -> n ) where
  logImpl lvl lgr opt = \f -> logImpl lvl lgr ( opt <> [unsafeToForeign f] )

trace :: forall n. LogImpl n => Logger -> n
trace logger = logImpl "trace" logger []

debug :: forall n. LogImpl n => Logger -> n
debug logger = logImpl "debug" logger []

info :: forall n. LogImpl n => Logger -> n
info logger = logImpl "info" logger []

warn :: forall n. LogImpl n => Logger -> n
warn logger = logImpl "warn" logger []

error :: forall n. LogImpl n => Logger -> n
error logger = logImpl "error" logger []

fatal :: forall n. LogImpl n => Logger -> n
fatal logger = logImpl "fatal" logger []

custom :: forall n. LogImpl n => Logger -> String -> n
custom logger lvl = logImpl lvl logger []
