module GameOfLife.State exposing (init, update, subscriptions)

import GameOfLife.Types exposing(..)

import Phoenix
import Phoenix.Socket as Socket
import Phoenix.Channel as Channel

-- MODEL

init : (Model, Cmd Msg)
init =
  (model, Cmd.none)

model : Model
model =
  { channelState = Disconnected
  , board = {id = -1}
  }

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  -- let
  --   msg = Debug.log "msg=" msg
  --   model = Debug.log "model=" model
  -- in
    case msg of
      NoOp ->
        (model, Cmd.none)

      UpdateState channelState ->
        ({model | channelState = channelState}, Cmd.none)

      JoinChannel ->
        ({model | channelState = Connecting}, Cmd.none)

      LeaveChannel ->
        ({model | channelState = Disconnecting}, Cmd.none)

      ReceiveBoardUpdate raw -> (model, Cmd.none)
          -- case JD.decodeValue roverUpdateDecoder raw of
          --   Ok rover ->
          --     ({model | rovers = updateRovers rover model.rovers}, Cmd.none)
          --
          --   Err error ->
          --       ( model, Cmd.none )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  case model.channelState of
    Connecting    -> Phoenix.connect socket [channel]
    Connected     -> Phoenix.connect socket [channel]
    _             -> Phoenix.connect socket []

channel : Channel.Channel Msg
channel =
  Channel.init "plateau:public"
  |> Channel.on "rover:update" ReceiveBoardUpdate
  |> Channel.onJoin  (\_ -> UpdateState Connected)
  |> Channel.onLeave (\_ -> UpdateState Disconnected)

socket : Socket.Socket
socket =
  Socket.init "ws://localhost:4000/socket/websocket"
