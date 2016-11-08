module GameOfLife.IO exposing (..)

import GameOfLife.Types exposing (..)

import Json.Decode as JD exposing ((:=))

boardUpdateDecoder : JD.Decoder Board
boardUpdateDecoder =
    JD.object3 Board
        ("generationNumber" := JD.int)
        ("size" := pointDecoder)
        ("aliveCells" := JD.list pointDecoder)

pointDecoder : JD.Decoder Point
pointDecoder =
  JD.tuple2 (,) JD.int JD.int

tickerUpdateDecoder : JD.Decoder Ticker
tickerUpdateDecoder =
  JD.object2 buildTicker
      ("started" := JD.bool)
      ("interval" := JD.int)

buildTicker : Bool -> Int -> Ticker
buildTicker started interval =
  let
    state = (case started of
              True -> Started
              False -> Stopped)
  in
    Ticker state interval
