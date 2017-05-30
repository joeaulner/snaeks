module Model exposing (Msg(..), Model, Snake, Vector, Direction(..), Point, init)


type Msg
    = Tick
    | SpawnFood ( Int, Int )


type alias Model =
    { snake : Snake
    , food : Maybe Point
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
    Model initSnake Nothing ! []


initSnake : Snake
initSnake =
    [ Vector 15 15 North, Vector 15 14 North, Vector 15 13 North ]
