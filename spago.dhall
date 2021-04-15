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
}
