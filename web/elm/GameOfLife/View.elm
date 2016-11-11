module GameOfLife.View exposing (view)

import GameOfLife.Types exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes as A exposing (..)
import Dict

view : Model -> Html Msg
view model =
  div []
    [ controlPanel model
    , boardView model
    ]

controlPanel : Model -> Html Msg
controlPanel model =
  div [ class "row" ] [ controlPanelMenuView model  ]

tickerSlider : Model -> Html Msg
tickerSlider model =
  div []
    (case model.ticker.state of
      Unknown ->
        []
      _ ->
        [ input
            [ type' "range"
            , A.min "0"
            , A.max "1000"
            , A.step "20"
            , value <| toString model.tickerSliderPosition
            , onInput UpdateTickerInterval
            ] []
        , text <| toString model.ticker.interval
        ]
    )

boardView : Model -> Html Msg
boardView model =
  div [ class "row"]
    [div [ class "boardContainer col-md-12" ]
      (case model.board.size of
        (0,0) ->  [ div [ class "noBoard" ] [text "No board data"] ]
        _     ->  [ div [ class "fullScreenButton fa fa-2x fa-arrows-alt pull-right pointer", onClick ToFullScreenClicked] []
                  , div [ class "board", boardStyle model.board.size] (aliveCellsView model.board)
                  ]
      )
    ]

aliveCellsView : Board -> List (Html Msg)
aliveCellsView board =
    List.map (aliveCellView board) board.aliveCells

boardStyle : Point -> Attribute Msg
boardStyle (x,y) =
  style
    [ ("width", toString(x) ++ "vw")
    , ("height", toString(y) ++ "vw")
    ]

aliveCellView : Board -> Point -> Html Msg
aliveCellView board (x,y) =
  let
  realAge =
   (case (Dict.get (toString(x) ++ "," ++ toString(y)) board.cellAttributes) of
     Just attr -> attr.age
     Nothing -> 10)
  in
    i [class "cell fa fa-square", cellStyle board.origin (x,y) realAge] []

cellStyle : Point -> Point -> Int -> Attribute Msg
cellStyle (initial_x, initial_y) (x,y) age =
  style
    [ ("bottom", toString(y - initial_y) ++ "vw")
    , ("left", toString(x - initial_x) ++ "vw")
    , ("color", hslToString( colorAlg2 age ))
    ]

hslToString : (Int, Int, Int) -> String
hslToString (h, s, l) =
  "hsl(" ++ (toString h) ++ "," ++ (toString s) ++ "%," ++ (toString l) ++ "%)"

colorAlg1 : Int -> (Int, Int, Int)
colorAlg1 age =
  (rem (age * 17) 255, 100, 50)

colorAlg2 : Int -> (Int, Int, Int)
colorAlg2 age =
  (rem (round (((toFloat age) ^ 0.8) * 17)) 255, 100, 50)

colorAlg3 : Int -> (Int, Int, Int)
colorAlg3 age =
  (150, 60, (Basics.max (60 - age * 8) 0))


tickerButton : TickerState -> Html Msg
tickerButton state =
  let
    (buttonClass, msg) =
      case state of
        Started         -> ("btn-danger  fa-pause", StopTicker)
        RequestingStop  -> ("btn-warning fa-pause", StopTicker)
        Stopped         -> ("btn-success fa-play",  StartTicker)
        RequestingStart -> ("btn-warning fa-play",  StartTicker)
        _               -> ("hide", NoOp)
  in
    button [ class ("btn fa " ++ buttonClass), onClick msg ] []

controlPanelMenuView : Model -> Html Msg
controlPanelMenuView model =
  div [ class "control_panel" ]
    [ div [ class "col-md-2 info" ] [ kbd [] [text ("Grid: " ++ (toString model.gridChannelState)) ]]
    , div [ class "col-md-2 info" ] [ kbd [] [text ("Generation: " ++ (toString model.board.generation)) ] ]
    , div [ class "col-md-1" ] [ tickerButton model.ticker.state ]
    , div [ class "col-md-1" ] [ tickerSlider model ]
    , div [ class "col-md-1" ] []
    , div [ class "col-md-2 info" ] [ kbd [] [text ("Board: " ++ (toString model.boardChannelState)) ]]
    , div [ class "col-md-3" ] [ selectBoard model.availableBoards ]
    ]

selectBoard : List String -> Html Msg
selectBoard availableBoards =
  select [ class "form-control", id "board-select", onInput OnBoardSelected ]
    ( availableBoardsOptions availableBoards )

availableBoardsOptions : List BoardId -> List (Html Msg)
availableBoardsOptions availableBoards =
  List.map availableBoard availableBoards

availableBoard : String -> Html Msg
availableBoard availableBoard =
  option [] [ text availableBoard ]
