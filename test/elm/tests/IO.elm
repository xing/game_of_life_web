module IO exposing (..)
import Test exposing (..)
import Expect
import GameOfLife.IO as IO
import GameOfLife.Types exposing (..)
import Json.Decode
import Dict

type DecoderTest output
      = Pass String output String -- Pass desc expected inputJson
      | Fail String String        -- Fail desc inputJson

all : Test
all =
    describe "IO"
        [ testDecoder IO.boardUpdateDecoder
          [ Pass "Minimum valid" { generation = 5, size = (5,6), aliveCells = [], cellAttributes = Dict.fromList [] } """ {"generation": 5, "size": [5,6], "aliveCells": [], "cellAttributes": {} """
          , Pass "With aliveCells" { generation = 5, size = (5,6), aliveCells = [(3,4), (2,3)] } """ {"generation": 5, "size": [5,6], "aliveCells": [[3,4],[2,3]]} """
          , Fail "Missing field" """ {"size": [5,6], "aliveCells": []} """
          ]
        , testDecoder IO.tickerUpdateDecoder
          [ Pass "Ticker started" { state = Started, interval = 10 } """ {"started": true, "interval": 10} """
          , Pass "Ticker stopped" { state = Stopped, interval = 10 } """ {"started": false, "interval": 10} """
          , Fail "Missing field" """ {"started": false} """
          ]
        ]

testDecoder : Json.Decode.Decoder output -> List (DecoderTest output) -> Test
testDecoder decoder tests =
  describe "test decoder"
    (List.map (testDecode decoder) tests)

testDecode : Json.Decode.Decoder output -> DecoderTest output -> Test
testDecode decoder decoderTest =
  case decoderTest of
    Pass desc expected json ->
      test desc <|
        \() ->
          Expect.equal (Ok expected) (Json.Decode.decodeString decoder json)

    Fail desc json ->
      test desc <|
        \() ->
          case Json.Decode.decodeString decoder json of
            Err _ ->
              Expect.pass
            Ok y ->
              Expect.fail "Should give error but was decoded"
