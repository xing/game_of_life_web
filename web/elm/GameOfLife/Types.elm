module GameOfLife.Types exposing (..)

import Json.Encode as JE
import Dict

type alias Model =
  { flags : Flags
  , gridChannelState : ChannelState
  , boardChannelState : ChannelState
  , ticker : Ticker
  , board : Board
  , tickerSliderPosition : Int
  , availableBoards : List BoardId
  , selectedBoard : BoardId
  }

type alias Flags =
  { host : String
  }

type alias Point =
  (Int, Int)

type ChannelState
    = Connecting
    | Connected
    | Disconnecting
    | Disconnected

type Msg
      = NoOp
      | JoinBoardChannel
      | LeaveBoardChannel
      | ReceiveBoardUpdate JE.Value
      | ReceiveTickerUpdate JE.Value
      | ReceiveGridChannelJoin JE.Value
      | ReceiveGridChannelLeave JE.Value
      | ReceiveGridChannelDisconnect
      | StopTicker
      | StartTicker
      | UpdateTickerInterval String
      | ToFullScreenClicked
      | OnBoardSelected BoardId
      | ReceiveBoardChannelJoin BoardId JE.Value
      | ReceiveBoardChannelLeave BoardId JE.Value
      | ReceiveBoardChannelDisconnect

type alias Ticker =
    { state : TickerState
    , interval : Int
    }

type TickerState
    = Started
    | Stopped
    | RequestingStop
    | RequestingStart
    | Unknown

type alias Board =
  { generation : Int
  , size : Point
  , aliveCells : List Point
  , origin : Point
  , cellAttributes : Dict.Dict String CellAttribute
  }

type alias CellAttribute =
  { age : Int
  }

type alias BoardId = Point
