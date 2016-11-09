module GameOfLife.View exposing (view)

import GameOfLife.Types exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes as A exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ controlPanel model
    , boardView model.board
    ]

controlPanel : Model -> Html Msg
controlPanel model =
  div [ class "row" ]
    [ controlPanelMenuView model,
      div [] [
        span [ id "menu_icon", class "pointer fa fa-bars", onClick (UpdateControlPanelMenu model.controlPanelMenuState) ] []
        , span [ id "fullscreen_button", class "fa fa-arrows-alt pointer marginRight15 pull-right", onClick ToFullScreenClicked ] []
      ]
    ]

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
    [ ("width", toString(x) ++ "vw")
    , ("height", toString(y) ++ "vw")
    ]

aliveCellView : Point -> Html Msg
aliveCellView cell =
  i [class "cell fa fa-bug", cellStyle cell] []

cellStyle : Point -> Attribute Msg
cellStyle (x,y) =
  style
    [ ("bottom", toString(y) ++ "vw")
    , ("left", toString(x) ++ "vw")
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
    Started -> button [ class "btn btn-danger", onClick StopTicker ] [text "Stop"]
    RequestingStop -> button [ class "btn btn-warning", onClick StopTicker ] [text "Requesting stop"]
    Stopped -> button [ class "btn btn-success", onClick StartTicker ] [text "Start"]
    RequestingStart -> button [ class "btn btn-warning", onClick StartTicker ] [text "Requesting start"]
    _       -> button [ class "hide" ] []

controlPanelMenuView : Model -> Html Msg
controlPanelMenuView model =
  div [ class ("control_panel " ++ (controlPanelMenuClass model.controlPanelMenuState)) ] [
      div [ id "actions" ] [ div [ class "col-md-2 gen_number" ] [ kbd [] [text ("Generation: " ++ (toString model.board.generation)) ] ]
                            , div [ class "col-md-1" ] [ connectButtonView model.channelState ]
                            , div [ class "col-md-2" ] [ tickerButton model.ticker.state ]
                            , div [ class "col-md-2" ] [ tickerSlider model ]
                           ]
      , div [ class "col-md-5" ] [ a [class "fa fa-times pointer pull-right", onClick (UpdateControlPanelMenu Displayed)] [] ]
      ]

controlPanelMenuClass : ControlPanelMenuState -> String
controlPanelMenuClass controlPanelMenuState =
  case controlPanelMenuState of
    Displayed -> "with_height"
    Hidden -> "no_height"
