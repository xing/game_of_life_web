module App exposing (..)

import GameOfLife.State as State
import GameOfLife.View as View
import GameOfLife.Types exposing (Flags, Model, Msg)
import Html

main : Program Flags Model Msg
main =
  Html.programWithFlags
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.view
        }
