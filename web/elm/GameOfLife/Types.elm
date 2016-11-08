module GameOfLife.Types exposing (..)

import Json.Encode as JE

type alias Model =
  { flags : Flags
  , channelState : ChannelState
  , ticker : Ticker
  , board : Board
  , tickerSliderPosition : Int
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
      | UpdateState ChannelState
      | JoinChannel
      | LeaveChannel
      | ReceiveBoardUpdate JE.Value
      | ReceiveTickerUpdate JE.Value
      | ReceiveChannelJoin JE.Value
      | StopTicker
      | StartTicker
      | UpdateTickerInterval String

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
  { generationNumber : Int
  , size : Point
  , aliveCells : List Point
  }
