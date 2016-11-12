module GameOfLife.Helpers exposing (..)

import GameOfLife.Types exposing(..)

import String

boardIdToString : BoardId -> String
boardIdToString = pointToString

stringToBoardId : String -> BoardId
stringToBoardId = stringToPoint

pointToString : Point  -> String
pointToString (x,y) =
  (toString x) ++ "," ++ (toString y)

stringToPoint : String -> Point
stringToPoint s =
  case String.split "," s of
    [x,y] -> (Result.withDefault 0 (String.toInt x), Result.withDefault 0 (String.toInt y))
    _     -> (0,0)
