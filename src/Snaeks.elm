module Snaeks exposing (main)

import Html exposing (program, div, text)
import Snaeks.Model as Model
import Snaeks.Update as Update
import Snaeks.View as View


main =
    program
        { init = Model.init
        , update = Update.update
        , subscriptions = Update.subscriptions
        , view = View.view
        }
