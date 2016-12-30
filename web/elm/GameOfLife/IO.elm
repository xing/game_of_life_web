module GameOfLife.IO exposing (..)

import GameOfLife.Types exposing (..)

import Json.Decode as JD exposing (field, index)
import Dict

boardUpdateDecoder : JD.Decoder Board
boardUpdateDecoder =
    JD.map5 Board
        (field "generation" JD.int)
        (field "size" pointDecoder)
        (field "aliveCells" (JD.list pointDecoder))
        (field "origin" pointDecoder)
        (field "cellAttributes" cellAttributesDecoder)

cellAttributesDecoder : JD.Decoder (Dict.Dict String CellAttribute)
cellAttributesDecoder =
  JD.dict cellAttributeDecoder

cellAttributeDecoder : JD.Decoder CellAttribute
cellAttributeDecoder =
  JD.map buildCellAttribute
      (field "age" JD.int)

buildCellAttribute : Int -> CellAttribute
buildCellAttribute age =
  CellAttribute age

pointDecoder : JD.Decoder Point
pointDecoder =
  JD.map2 (,) (index 0 JD.int) (index 1 JD.int)


gridJoinResponseDecoder : JD.Decoder (List BoardId, Ticker)
gridJoinResponseDecoder =
  JD.map2 (,)
    (field "boards" boardsDecoder)
    (field "ticker" tickerUpdateDecoder)


boardsDecoder : JD.Decoder (List BoardId)
boardsDecoder = JD.list pointDecoder

tickerUpdateDecoder : JD.Decoder Ticker
tickerUpdateDecoder =
  JD.map2 buildTicker
      (field "started" JD.bool)
      (field "interval" JD.int)

buildTicker : Bool -> Int -> Ticker
buildTicker started interval =
  let
    state = (case started of
              True -> Started
              False -> Stopped)
  in
    Ticker state interval
