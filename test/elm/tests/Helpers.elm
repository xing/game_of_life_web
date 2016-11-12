module Helpers exposing (..)
import Test exposing (..)
import Expect
import GameOfLife.Helpers exposing (..)

all : Test
all =
    describe "Helpers"
    [ test "pointToString" <| \() -> Expect.equal "1,2" (pointToString (1,2))
    , test "stringToPoint" <| \() -> Expect.equal (10,11) (stringToPoint "10,11")
    , test "stringToPoint" <| \() -> Expect.equal (0,11) (stringToPoint "a,11")
    , test "stringToPoint" <| \() -> Expect.equal (0,0) (stringToPoint "foo")
    ]
