module Main exposing (main)

import Html exposing (program, div, text)
import Model
import Update
import View


main =
    program
        { init = Model.init
        , update = Update.update
        , subscriptions = Update.subscriptions
        , view = View.view
        }
