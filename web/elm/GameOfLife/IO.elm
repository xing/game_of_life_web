module GameOfLife.IO exposing (..)

import GameOfLife.Types exposing (..)

import Json.Decode as JD exposing ((:=))

boardUpdateDecoder : JD.Decoder Board
boardUpdateDecoder =
    JD.object2 Board
        ("id" := JD.int)
        ("generationNumber"  := JD.int)
