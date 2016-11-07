module GameOfLife.View exposing (view)

import GameOfLife.Types exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ div [ class "board" ] [ text ("Board " ++ toString(model.board.generationNumber)) ]
    , connectButtonView model.channelState
    ]

connectButtonView : ChannelState -> Html Msg
connectButtonView state =
  case state of
    Disconnected  -> button [ onClick JoinChannel ]   [ text "Connect" ]
    Connected     -> button [ onClick LeaveChannel ]  [ text "Disconnect" ]
    Connecting    -> button [] [ text "Connecting.." ]
    Disconnecting -> button [] [ text "Disonnecting.." ]
