module Snaeks exposing (main)

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import World exposing (World)


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


init : ( Model, Cmd Msg )
init =
    Model "" "" False World.init ! []


type alias Model =
    { name : String
    , nameError : String
    , started : Bool
    , world : World
    }


type Msg
    = NameInput String
    | JoinGame
    | GameTick String


type UserAction
    = NoOp
    | ChangeDirection Direction
    | Start


type Direction
    = North
    | East
    | South
    | West



-- UPDATE


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        socket =
            if model.started then
                WebSocket.listen ("ws://localhost:5000/game?name=" ++ model.name) GameTick
            else
                Sub.none
    in
        Sub.batch [ socket ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NameInput name ->
            { model | name = name } ! []

        JoinGame ->
            if String.length model.name < 3 then
                { model | nameError = "Screen name must be at least 3 characters" } ! []
            else
                { model | started = True, nameError = "" } ! []

        GameTick json ->
            { model | world = World.update json model.world } ! []



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ a
            [ href "https://github.com/pancakeCaptain/snaeks"
            , target "_blank"
            , rel "noopener"
            ]
            [ img
                [ class "fork-me"
                , alt "Fork me on GitHub"
                , src "http://localhost:5000/images/fork-me.png"
                ]
                []
            ]
        , div []
            [ h1 [] [ text "Welcome to Snæks!" ]
            , div [ class "instructions" ]
                [ div [] [ text "Use WASD to move" ]
                , div [] [ text "Press [SPACE] to start" ]
                ]
            ]
        , if model.started then
            World.view model.world
          else
            div []
                [ input [ placeholder "Screen Name", onInput NameInput ] []
                , button [ onClick JoinGame ] [ text "Join Game" ]
                ]
        , if String.isEmpty model.nameError then
            text ""
          else
            div [ class "error" ] [ text model.nameError ]
        ]
