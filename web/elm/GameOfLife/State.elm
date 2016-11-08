module GameOfLife.State exposing (init, update, subscriptions)

import GameOfLife.Types exposing(..)
import GameOfLife.IO exposing(..)

import Phoenix
import Phoenix.Socket as Socket
import Phoenix.Channel as Channel
import Phoenix.Push as Push
import Json.Decode as JD exposing (decodeValue)
import String

-- MODEL

init : Flags -> (Model, Cmd Msg)
init flags =
  (model flags, Cmd.none)

model : Flags -> Model
model flags =
  { flags = flags
  , ticker = {state = Unknown, interval = 0}
  , channelState = Disconnected
  , board = {generationNumber = 1, size = (10, 10), aliveCells = []}
  , tickerSliderPosition = 10
  }

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    msg = Debug.log "msg=" msg
    model = Debug.log "model=" model
  in
    case msg of
      NoOp ->
        (model, Cmd.none)

      UpdateState channelState ->
        ({model | channelState = channelState}, Cmd.none)

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
          push = Push.init "board:public" "ticker:interval_update"
        in
          ({model | tickerSliderPosition = (Result.withDefault 0 (String.toInt newInterval))},
            Phoenix.push (socketName model.flags.host) push)

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
  |> Channel.onLeave (\_ -> UpdateState Disconnected)
  |> Channel.withDebug


socket : String -> Socket.Socket
socket host =
  Socket.init (socketName host)

socketName : String -> String
socketName host =
  "ws://" ++ host ++  "/socket/websocket"
