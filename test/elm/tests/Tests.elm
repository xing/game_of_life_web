module Tests exposing (..)
import IO
import Helpers
import Test exposing (..)
all : Test
all =
    describe "Test suite"
        [
          IO.all
        , Helpers.all
        ]
