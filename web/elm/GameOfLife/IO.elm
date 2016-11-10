module GameOfLife.IO exposing (..)

import GameOfLife.Types exposing (..)

import Json.Decode as JD exposing ((:=))
import Dict

boardUpdateDecoder : JD.Decoder Board
boardUpdateDecoder =
    JD.object5 Board
        ("generation" := JD.int)
        ("size" := pointDecoder)
        ("aliveCells" := JD.list pointDecoder)
        ("origin" := pointDecoder)
        ("cellAttributes" := cellAttributesDecoder)

cellAttributesDecoder : JD.Decoder (Dict.Dict String CellAttribute)
cellAttributesDecoder =
  JD.dict cellAttributeDecoder

cellAttributeDecoder : JD.Decoder CellAttribute
cellAttributeDecoder =
  JD.object1 buildCellAttribute
      ("age" := JD.int)

buildCellAttribute : Int -> CellAttribute
buildCellAttribute age =
  CellAttribute age

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
