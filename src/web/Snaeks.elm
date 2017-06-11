module Snaeks exposing (main)

import Char
import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Keyboard exposing (KeyCode)
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
    | UserInput KeyCode


type Direction
    = North
    | East
    | South
    | West



-- UPDATE


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.started then
        let
            webSocket =
                WebSocket.listen ("ws://localhost:5000/game?name=" ++ model.name) GameTick

            keyboard =
                Keyboard.presses UserInput
        in
            Sub.batch [ webSocket, keyboard ]
    else
        Sub.none


update : Msg -> Model -> ( Model, Cmd msg )
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

        UserInput keyCode ->
            model ! [ handleUserInput model keyCode ]


handleUserInput : Model -> KeyCode -> Cmd msg
handleUserInput model keyCode =
    let
        send =
            sendMessage model
    in
        case Char.fromCode keyCode of
            'w' ->
                send "NORTH"

            'd' ->
                send "EAST"

            's' ->
                send "SOUTH"

            'a' ->
                send "WEST"

            _ ->
                Cmd.none


sendMessage : Model -> String -> Cmd msg
sendMessage model str =
    WebSocket.send ("ws://localhost:5000/game?name=" ++ model.name) str



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
