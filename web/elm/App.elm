module App exposing (..)

import GameOfLife.State as State
import GameOfLife.View as View
import GameOfLife.Types exposing (Flags)
import Html.App

main : Program Flags
main =
    Html.App.programWithFlags
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.view
        }
