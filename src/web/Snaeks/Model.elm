module Snaeks.Model
    exposing
        ( Msg(..)
        , Model
        , Snake
        , Direction(..)
        , Point
        , UserAction(..)
        , init
        , worldSize
        )


type Msg
    = SocketTick String
    | UserInput UserAction


type UserAction
    = NoOp
    | ChangeDirection Direction
    | Reset
    | Start


type alias Model =
    { snake : Snake
    , food : Maybe Point
    }


type alias Snake =
    List Point


type alias Point =
    { x : Int
    , y : Int
    }


type Direction
    = North
    | East
    | South
    | West


init : ( Model, Cmd Msg )
init =
    Model [] Nothing ! []


worldSize : Int
worldSize =
    32
