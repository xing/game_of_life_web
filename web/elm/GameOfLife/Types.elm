module GameOfLife.Types exposing (..)

import Json.Encode as JE

type alias Model =
  { flags : Flags
  , gridChannelState : ChannelState
  , boardChannelState : ChannelState
  , ticker : Ticker
  , board : Board
  , tickerSliderPosition : Int
  , controlPanelMenuState : ControlPanelMenuState
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
      | StopTicker
      | StartTicker
      | UpdateTickerInterval String
      | UpdateControlPanelMenu ControlPanelMenuState
      | ToFullScreenClicked
      | OnBoardSelected BoardId
      | ReceiveBoardChannelJoin JE.Value
      | ReceiveBoardChannelLeave JE.Value

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

type ControlPanelMenuState
    = Displayed
    | Hidden

type alias Board =
  { generation : Int
  , size : Point
  , aliveCells : List Point
  }

type alias BoardId = String
