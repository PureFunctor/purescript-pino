module Node.Pino.Logger.Do where

import Prelude hiding (bind)

import Node.Pino.Logger (LoggerM)


bind :: forall r. LoggerM r -> ( Unit -> LoggerM r ) -> LoggerM Unit
bind x f = void x *> void ( f unit )


discard :: forall r. LoggerM r -> ( Unit -> LoggerM r ) -> LoggerM Unit
discard = bind
