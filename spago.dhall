{ name = "pino"
, dependencies =
  [ "effect"
  , "foreign"
  , "foreign-object"
  , "functions"
  , "options"
  , "prelude"
  , "psci-support"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, repository = "https://github.com/PureFunctor/purescript-pino.git"
, license = "BSD-3-Clause"
}
