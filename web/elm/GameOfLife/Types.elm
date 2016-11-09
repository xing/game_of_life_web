module GameOfLife.Types exposing (..)

import Json.Encode as JE

type alias Model =
  { flags : Flags
  , channelState : ChannelState
  , ticker : Ticker
  , board : Board
  , tickerSliderPosition : Int
  , controlPanelMenuState : ControlPanelMenuState
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
      | JoinChannel
      | LeaveChannel
      | ReceiveBoardUpdate JE.Value
      | ReceiveTickerUpdate JE.Value
      | ReceiveChannelJoin JE.Value
      | ReceiveChannelLeave JE.Value
      | StopTicker
      | StartTicker
      | UpdateTickerInterval String
      | UpdateControlPanelMenu ControlPanelMenuState
      | ToFullScreenClicked

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
