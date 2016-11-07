module App exposing (..)

import GameOfLife.State as State
import GameOfLife.View as View

import Html.App

main : Program Never
main =
    Html.App.program
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.view
        }
