module IO exposing (..)
import Test exposing (..)
import Expect
import GameOfLife.IO as IO
import Json.Decode

type DecoderTest output
      = Pass String output String -- Pass desc expected inputJson
      | Fail String String        -- Fail desc inputJson

all : Test
all =
    describe "IO"
        [ testDecoder IO.boardUpdateDecoder
          [ Pass "Minimum valid" { generationNumber = 5, size = (5,6), aliveCells = [] } """ {"generationNumber": 5, "size": [5,6], "aliveCells": []} """
          , Pass "With aliveCells" { generationNumber = 5, size = (5,6), aliveCells = [(3,4), (2,3)] } """ {"generationNumber": 5, "size": [5,6], "aliveCells": [[3,4],[2,3]]} """
          , Fail "Missing field" """ {"size": [5,6], "aliveCells": []} """
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
