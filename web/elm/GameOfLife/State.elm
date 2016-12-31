module GameOfLife.State exposing (init, update, subscriptions)

import GameOfLife.Types exposing(..)
import GameOfLife.IO exposing(..)
import GameOfLife.Helpers exposing(..)
import GameOfLife.Ports as Ports

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
  , gridChannelState = Connecting
  , boardChannelState = Connecting
  , board = Nothing
  , tickerSliderPosition = 100
  , availableBoards = [(0,0)]
  , selectedBoard = (0,0)
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

      JoinBoardChannel ->
        ({model | boardChannelState = Connecting}, Cmd.none)

      LeaveBoardChannel ->
        ({model | boardChannelState = Disconnecting}, Cmd.none)

      ReceiveBoardUpdate json ->
          case JD.decodeValue boardUpdateDecoder json of
            Ok board ->
              ({model | board = Just board}, Cmd.none)

            Err error ->
                ( model, Cmd.none )

      ReceiveTickerUpdate json ->
          case JD.decodeValue tickerUpdateDecoder json of
            Ok ticker ->
              ({model | ticker = ticker}, Cmd.none)

            Err error ->
                ( model, Cmd.none )

      ReceiveGridChannelJoin json ->
          case JD.decodeValue gridJoinResponseDecoder json of
            Ok (boards, ticker) ->
              ({model | ticker = ticker
                      , availableBoards = boards
                      , tickerSliderPosition = ticker.interval
                      , gridChannelState = Connected },
              Cmd.none)

            Err error ->
                ( model, Cmd.none )

      ReceiveGridChannelLeave json ->
          ({model | gridChannelState = Disconnected, ticker = updateTickerState Unknown model.ticker}, Cmd.none)

      ReceiveGridChannelDisconnect ->
          ({model | gridChannelState = Connecting, ticker = updateTickerState Unknown model.ticker}, Cmd.none)

      StopTicker ->
        let
          push = Push.init "grid" "ticker:stop"
        in
          ({model | ticker = updateTickerState RequestingStop model.ticker},
            Phoenix.push (socketName model.flags.host) push)

      StartTicker ->
        let
          push = Push.init "grid" "ticker:start"
        in
          ({model | ticker = updateTickerState RequestingStart model.ticker},
            Phoenix.push (socketName model.flags.host) push)

      UpdateTickerInterval newInterval ->
        let
          newIntervalInt = Result.withDefault 0 (String.toInt newInterval)
          push = Push.init "grid" "ticker:interval_update"
          |> Push.withPayload (JE.object [ ( "newInterval", JE.int newIntervalInt) ])
        in
          ({model | tickerSliderPosition = newIntervalInt},
            Phoenix.push (socketName model.flags.host) push)

      ToFullScreenClicked ->
        (model, Ports.requestFullScreen "on")

      OnBoardSelected newSelectedBoard ->
        ({model | selectedBoard = newSelectedBoard, board = Nothing} , Cmd.none)

      ReceiveBoardChannelJoin boardId json ->
          ({model | boardChannelState = Connected}, Cmd.none)

      ReceiveBoardChannelDisconnect ->
          ({model | boardChannelState = Connecting}, Cmd.none)

      ReceiveBoardChannelLeave boardId json ->
        -- Only disconnnect from selected board
        if boardId == model.selectedBoard then
          ({model | boardChannelState = Disconnected}, Cmd.none)
        else
          (model, Cmd.none)


updateTickerState : TickerState -> Ticker -> Ticker
updateTickerState tickerState ticker =
  {ticker | state = tickerState}

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  let
    channels = []
    channels2 = case model.gridChannelState of
      Connecting -> gridChannel :: channels
      Connected -> gridChannel :: channels
      _         -> channels

    channels3 = case model.boardChannelState of
      Connecting -> (boardChannel model.selectedBoard) :: channels2
      Connected -> (boardChannel model.selectedBoard) :: channels2
      _         -> channels2

  in
    Phoenix.connect (socket model.flags.host) channels3



gridChannel : Channel.Channel Msg
gridChannel =
  Channel.init "grid"
  |> Channel.on "ticker:update" ReceiveTickerUpdate
  |> Channel.onJoin ReceiveGridChannelJoin
  |> Channel.onLeave ReceiveGridChannelLeave
  |> Channel.onDisconnect ReceiveGridChannelDisconnect
  |> Channel.withDebug

boardChannel : BoardId -> Channel.Channel Msg
boardChannel boardId =
  Channel.init ("board:" ++ boardIdToString(boardId))
  |> Channel.on "board:update" ReceiveBoardUpdate
  |> Channel.onJoin (ReceiveBoardChannelJoin boardId)
  |> Channel.onLeave (ReceiveBoardChannelLeave boardId)
  |> Channel.onDisconnect ReceiveBoardChannelDisconnect
  |> Channel.withDebug

socket : String -> Socket.Socket Msg
socket host =
  Socket.init (socketName host)

socketName : String -> String
socketName host =
  "ws://" ++ host ++  "/socket/websocket"
