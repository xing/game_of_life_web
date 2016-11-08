module GameOfLife.View exposing (view)

import GameOfLife.Types exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ connectButtonView model.channelState
    , boardView model.board
    ]

boardView : Board -> Html Msg
boardView board =
  div [ class "boardContainer" ]
    [ div [] [text ("generationNumber " ++ (toString board.generationNumber)) ]
    , div [ class "board", boardStyle board.size]
        (aliveCellsView board.aliveCells)
    ]

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

cellStyle : Point -> Attribute msg
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
