let Package = { name : Text, version : Text, repo : Text, dependencies : List Text }
in  [
  { name = "testing"
  , version = "main" -- NOTE: use a tag/release instead of main branch!
  , repo = "https://github.com/internet-computer/testing"
  , dependencies = [] : List Text
  }
] : List Package
