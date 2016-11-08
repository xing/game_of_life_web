module GameOfLife.View exposing (view)

import GameOfLife.Types exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ boardView model.board
    , connectButtonView model.channelState
    ]

boardView : Board -> Html Msg
boardView board =
  div [ class "board" ]
    [ div [] [text ("generationNumber " ++ (toString board.generationNumber)) ]
    , div [] [text ("size " ++ (toString board.size))]
    , aliveCellsView board.aliveCells
    ]

aliveCellsView : List Point -> Html Msg
aliveCellsView aliveCells =
  div []
    (List.map aliveCellView aliveCells)

aliveCellView : Point -> Html Msg
aliveCellView cell =
  i [class "fa fa-bug"] [text (toString cell)]

connectButtonView : ChannelState -> Html Msg
connectButtonView state =
  case state of
    Disconnected  -> button [ onClick JoinChannel ]   [ text "Connect" ]
    Connected     -> button [ onClick LeaveChannel ]  [ text "Disconnect" ]
    Connecting    -> button [] [ text "Connecting.." ]
    Disconnecting -> button [] [ text "Disonnecting.." ]
