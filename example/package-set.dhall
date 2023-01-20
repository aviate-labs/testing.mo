let Package = { name : Text, version : Text, repo : Text, dependencies : List Text }
in  [
  { name = "testing"
  , version = "v0.1.0"
  , repo = "https://github.com/internet-computer/testing"
  , dependencies = [] : List Text
  }
] : List Package
