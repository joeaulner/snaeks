module Model exposing (Msg(..), Model, Snake, Vector, Direction, init)


type Msg
    = NoOp


type alias Model =
    { snake : Snake }


type alias Snake =
    List Vector


type alias Vector =
    { x : Int
    , y : Int
    , d : Direction
    }


type Direction
    = North
    | East
    | South
    | West


init : ( Model, Cmd Msg )
init =
    Model initSnake ! []


initSnake : Snake
initSnake =
    [ Vector 15 15 North, Vector 15 14 North, Vector 15 13 North ]
