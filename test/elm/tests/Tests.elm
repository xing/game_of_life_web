module Tests exposing (..)
import IO
import Test exposing (..)
all : Test
all =
    describe "Test suite"
        [
          IO.all
        ]
