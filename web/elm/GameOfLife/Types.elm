module GameOfLife.Types exposing (..)

import Json.Encode as JE

type alias Model =
  { channelState : ChannelState
  , board : Board
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

type alias Board =
  { generationNumber : Int
  , size : Point
  , aliveCells : List Point
  }
