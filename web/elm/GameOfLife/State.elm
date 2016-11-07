module GameOfLife.State exposing (init, update, subscriptions)

import GameOfLife.Types exposing(..)
import GameOfLife.IO exposing(..)

import Phoenix
import Phoenix.Socket as Socket
import Phoenix.Channel as Channel
import Json.Decode as JD exposing (decodeValue)

-- MODEL

init : (Model, Cmd Msg)
init =
  (model, Cmd.none)

model : Model
model =
  { channelState = Disconnected
  , board = {generationNumber = 1, size = (10, 10), aliveCells = []}
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

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  case model.channelState of
    Connecting    -> Phoenix.connect socket [channel]
    Connected     -> Phoenix.connect socket [channel]
    _             -> Phoenix.connect socket []

channel : Channel.Channel Msg
channel =
  Channel.init "board:public"
  |> Channel.on "board:update" ReceiveBoardUpdate
  |> Channel.onJoin  (\_ -> UpdateState Connected)
  |> Channel.onLeave (\_ -> UpdateState Disconnected)

socket : Socket.Socket
socket =
  Socket.init "ws://localhost:4000/socket/websocket"
