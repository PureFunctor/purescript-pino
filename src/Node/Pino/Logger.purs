module Node.Pino.Logger where

import Prelude

import Data.Function.Uncurried (Fn3, runFn3)
import Data.Options (Option, Options(..), opt, options)
import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
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
  logImpl :: String -> ( Array Foreign ) -> n

instance logImplBase :: LogImpl ( LoggerM r ) where
  logImpl lvl opt = unsafeCoerce $ LoggerM \logger -> runFn3 _logImpl lvl logger opt

else instance logImplP :: LogImpl n => LogImpl ( f -> n ) where
  logImpl lvl opt = \f -> logImpl lvl ( opt <> [unsafeToForeign f] )

trace :: forall n. LogImpl n => n
trace = logImpl "trace" []

debug :: forall n. LogImpl n => n
debug = logImpl "debug" []

info :: forall n. LogImpl n => n
info = logImpl "info" []

warn :: forall n. LogImpl n => n
warn = logImpl "warn" []

error :: forall n. LogImpl n => n
error = logImpl "error" []

fatal :: forall n. LogImpl n => n
fatal = logImpl "fatal" []

custom :: forall n. LogImpl n => String -> n
custom lvl = logImpl lvl []

newtype LoggerM r = LoggerM ( Logger -> Effect r )

runLogger :: Logger -> LoggerM ~> Effect
runLogger logger ( LoggerM f ) =  f logger

instance functorLoggerM :: Functor LoggerM where
  map f ( LoggerM g ) = LoggerM (map f <<< g)

instance applyLoggerM :: Apply LoggerM where
  apply ( LoggerM f ) ( LoggerM g ) = LoggerM \logger -> do
    f' <- f logger
    g' <- g logger
    pure $ f' g'

instance applicativeLoggerM :: Applicative LoggerM where
  pure r = LoggerM \_ -> pure r

instance bindLoggerM :: Bind LoggerM where
  bind ( LoggerM f ) g = LoggerM \logger -> do
    f' <- f logger
    case g f' of
      LoggerM h -> h logger

instance monadLoggerM :: Monad LoggerM

instance monadEffectLoggerM :: MonadEffect LoggerM where
  liftEffect e = LoggerM \_ -> e
