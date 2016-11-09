port module GameOfLife.State exposing (init, update, subscriptions)

import GameOfLife.Types exposing(..)
import GameOfLife.IO exposing(..)

import Phoenix
import Phoenix.Socket as Socket
import Phoenix.Channel as Channel
import Phoenix.Push as Push
import Json.Decode as JD exposing (decodeValue)
import String
import Json.Encode as JE

-- MODEL

init : Flags -> (Model, Cmd Msg)
init flags =
  (model flags, Cmd.none)

model : Flags -> Model
model flags =
  { flags = flags
  , ticker = {state = Unknown, interval = 0}
  , channelState = Disconnected
  , board = {generation = 1, size = (95, 50), aliveCells = []}
  , tickerSliderPosition = 100
  , controlPanelMenuState = Displayed
  }

-- UPDATE

port requestFullScreen : String -> Cmd msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    msg = Debug.log "msg=" msg
    model = Debug.log "model=" model
  in
    case msg of
      NoOp ->
        (model, Cmd.none)

      JoinChannel ->
        ({model | channelState = Connecting}, Cmd.none)

      LeaveChannel ->
        ({model | channelState = Disconnecting}, Cmd.none)

      ReceiveBoardUpdate json ->
          case JD.decodeValue boardUpdateDecoder json of
            Ok board ->
              ({model | board = board}, Cmd.none)

            Err error ->
                ( model, Cmd.none )

      ReceiveTickerUpdate json ->
          case JD.decodeValue tickerUpdateDecoder json of
            Ok ticker ->
              ({model | ticker = ticker}, Cmd.none)

            Err error ->
                ( model, Cmd.none )

      ReceiveChannelJoin json ->
          case JD.decodeValue tickerUpdateDecoder json of
            Ok ticker ->
              ({model | ticker = ticker, channelState = Connected }, Cmd.none)

            Err error ->
                ( model, Cmd.none )

      ReceiveChannelLeave json ->
          ({model | channelState = Disconnected, ticker = updateTickerState Unknown model.ticker}, Cmd.none)

      StopTicker ->
        let
          push = Push.init "board:public" "ticker:stop"
        in
          ({model | ticker = updateTickerState RequestingStop model.ticker},
            Phoenix.push (socketName model.flags.host) push)

      StartTicker ->
        let
          push = Push.init "board:public" "ticker:start"
        in
          ({model | ticker = updateTickerState RequestingStart model.ticker},
            Phoenix.push (socketName model.flags.host) push)

      UpdateTickerInterval newInterval ->
        let
          newIntervalInt = Result.withDefault 0 (String.toInt newInterval)
          push = Push.init "board:public" "ticker:interval_update"
          |> Push.withPayload (JE.object [ ( "newInterval", JE.int newIntervalInt) ])
        in
          ({model | tickerSliderPosition = newIntervalInt},
            Phoenix.push (socketName model.flags.host) push)

      UpdateControlPanelMenu controlPanelMenuState ->
        case controlPanelMenuState of
          Displayed -> ({model | controlPanelMenuState = Hidden}, Cmd.none)
          Hidden -> ({model | controlPanelMenuState = Displayed}, Cmd.none)

      ToFullScreenClicked ->
        (model, requestFullScreen "on")



updateTickerState : TickerState -> Ticker -> Ticker
updateTickerState tickerState ticker =
  {ticker | state = tickerState}

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  case model.channelState of
    Connecting    -> Phoenix.connect (socket model.flags.host) [channel]
    Connected     -> Phoenix.connect (socket model.flags.host) [channel]
    _             -> Phoenix.connect (socket model.flags.host) []

channel : Channel.Channel Msg
channel =
  Channel.init "board:public"
  |> Channel.on "board:update" ReceiveBoardUpdate
  |> Channel.on "ticker:update" ReceiveTickerUpdate
  |> Channel.onJoin ReceiveChannelJoin
  |> Channel.onLeave ReceiveChannelLeave
  |> Channel.withDebug


socket : String -> Socket.Socket
socket host =
  Socket.init (socketName host)

socketName : String -> String
socketName host =
  "ws://" ++ host ++  "/socket/websocket"
