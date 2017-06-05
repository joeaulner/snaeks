module Snaeks.Model
    exposing
        ( Msg(..)
        , Model
        , Snake
        , Vector
        , Direction(..)
        , Point
        , UserAction(..)
        , init
        , worldSize
        )


type Msg
    = Tick
    | SpawnFood ( Int, Int )
    | UserInput UserAction


type UserAction
    = NoOp
    | ChangeDirection Direction
    | Reset
    | Start


type alias Model =
    { snake : Snake
    , food : Maybe Point
    , collision : Bool
    , started : Bool
    }


type alias Snake =
    List Vector


type alias Vector =
    { x : Int
    , y : Int
    , d : Direction
    }


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
    Model initSnake Nothing False False ! []


initSnake : Snake
initSnake =
    [ Vector 15 15 North, Vector 15 14 North, Vector 15 13 North ]


worldSize : Int
worldSize =
    32
