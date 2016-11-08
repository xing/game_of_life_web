module GameOfLife.View exposing (view)

import GameOfLife.Types exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ controlPanel model
    , boardView model.board
    ]

controlPanel : Model -> Html Msg
controlPanel model =
  div [ class "row" ]
    [ div [ class "col-md-2" ] [text ("generationNumber " ++ (toString model.board.generationNumber))]
    , div [ class "col-md-1" ] [ connectButtonView model.channelState ]
    , div [ class "col-md-9" ] [tickerButton model.ticker.state ]]

boardView : Board -> Html Msg
boardView board =
  div [ class "row"]
    [div [ class "boardContainer col-md-12" ]
      [ div [ class "board", boardStyle board.size]
          (aliveCellsView board.aliveCells)
      ]]

aliveCellsView : List Point -> List (Html Msg)
aliveCellsView aliveCells =
    List.map aliveCellView aliveCells

boardStyle : Point -> Attribute Msg
boardStyle (x,y) =
  style
    [ ("width", toString(x) ++ "em")
    , ("height", toString(y) ++ "em")
    ]

aliveCellView : Point -> Html Msg
aliveCellView cell =
  i [class "cell fa fa-bug", cellStyle cell] []

cellStyle : Point -> Attribute Msg
cellStyle (x,y) =
  style
    [ ("bottom", toString(y) ++ "em")
    , ("left", toString(x) ++ "em")
    ]

connectButtonView : ChannelState -> Html Msg
connectButtonView state =
  case state of
    Disconnected  -> button [ onClick JoinChannel, buttonClass state ]   [ text "Connect" ]
    Connected     -> button [ onClick LeaveChannel, buttonClass state ]  [ text "Disconnect" ]
    Connecting    -> button [ buttonClass state ] [ text "Connecting.." ]
    Disconnecting -> button [ buttonClass state ] [ text "Disonnecting.." ]

buttonClass : ChannelState -> Attribute Msg
buttonClass state =
  class (case state of
          Disconnected  -> "btn btn-success"
          Connected     -> "btn btn-danger"
          _             -> "btn btn-warning")

tickerButton : TickerState -> Html Msg
tickerButton state =
  case state of
    Unknown -> button [class "hide"] []
    Started -> button [ class "btn btn-danger" ] [text "Stop"]
    Stopped -> button [ class "btn btn-success" ] [text "Start"]
