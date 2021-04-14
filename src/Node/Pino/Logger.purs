module Node.Pino.Logger where

import Prelude

import Data.Options (Option, Options, opt, options)
import Effect (Effect)
import Foreign (Foreign)
import Foreign.Object (Object)

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

foreign import data Logger :: Type

foreign import _mkLogger :: Foreign -> Effect Logger

mkLogger :: Options LoggerOptions -> Effect Logger
mkLogger = _mkLogger <<< options
