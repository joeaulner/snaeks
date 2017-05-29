module Main exposing (main)

import Html exposing (Html, text, div)
import SvgTest


main : Html String
main =
    div []
        [ div [] [ text "Hello, World!" ]
        , SvgTest.view
        ]
