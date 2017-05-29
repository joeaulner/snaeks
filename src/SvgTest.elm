module SvgTest exposing (view)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


view : Html String
view =
    svg [ height "120", width "120", viewBox "0 0 120 120" ]
        [ rect [ x "10", y "10", width "100", height "100", rx "15", ry "15" ] [] ]
