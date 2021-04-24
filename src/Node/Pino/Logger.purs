module Node.Pino.Logger where

import Prelude

import Data.Function.Uncurried (Fn3, runFn3)
import Data.Options (Option, Options(..), opt, options)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Foreign (Foreign, unsafeToForeign)
import Foreign.Object (Object)
import Unsafe.Coerce (unsafeCoerce)


-- | Phantom type consumed by the `options` package
-- |
-- | Further documentation for options can be found in:
-- | https://github.com/pinojs/pino/blob/v6.11.3/docs/api.md#options
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


-- | Represents a `pino.logger` instance
foreign import data Logger :: Type

foreign import _mkLogger :: Foreign -> Effect Logger

-- | Creates a `Logger` with the provided `LoggerOptions`
mkLogger :: Options LoggerOptions -> Effect Logger
mkLogger = _mkLogger <<< options

-- | Creates a `Logger` using `defaultLoggerOptions`
defaultLogger :: Effect Logger
defaultLogger = mkLogger defaultLoggerOptions


foreign import _logImpl :: Fn3 String Logger ( Array Foreign ) ( Effect Unit )

-- | Generates variadic logging functions, ultimately
-- | terminating into a monad `LoggerM`
class LogImpl n where
  logImpl :: String -> ( Array Foreign ) -> n

instance logImplBase :: LogImpl ( LoggerM r ) where
  logImpl lvl opt = unsafeCoerce $ LoggerM \logger -> runFn3 _logImpl lvl logger opt

else instance logImplP :: LogImpl n => LogImpl ( f -> n ) where
  logImpl lvl opt = \f -> logImpl lvl ( opt <> [unsafeToForeign f] )


-- | Builds a `LoggerM` that calls into the `trace` method of a `Logger`
trace :: forall n. LogImpl n => n
trace = logImpl "trace" []

-- | Builds a `LoggerM` that calls into the `debug` method of a `Logger`
debug :: forall n. LogImpl n => n
debug = logImpl "debug" []

-- | Builds a `LoggerM` that calls into the `info` method of a `Logger`
info :: forall n. LogImpl n => n
info = logImpl "info" []

-- | Builds a `LoggerM` that calls into the `warn` method of a `Logger`
warn :: forall n. LogImpl n => n
warn = logImpl "warn" []

-- | Builds a `LoggerM` that calls into the `error` method of a `Logger`
error :: forall n. LogImpl n => n
error = logImpl "error" []

-- | Builds a `LoggerM` that calls into the `fatal` method of a `Logger`
fatal :: forall n. LogImpl n => n
fatal = logImpl "fatal" []

-- | Builds a `LoggerM` that calls into a custom method of a `Logger`
-- |
-- | Note: This does not check whether said method exists or not,
-- | making it unsafe.
custom :: forall n. LogImpl n => String -> n
custom lvl = logImpl lvl []


-- | A reader-like monad for logging methods
newtype LoggerM r = LoggerM ( Logger -> Effect r )

-- | Unwraps and runs `LoggerM` using the provided `Logger`
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
