module Snaeks.Update exposing (subscriptions, update)

import WebSocket
import Json.Decode as Json exposing (Decoder)
import Snaeks.Model as Model exposing (Model, Msg(..), Direction(..), Point, UserAction(..), Snake, worldSize)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ WebSocket.listen "ws://localhost:5000/hello" SocketTick
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SocketTick str ->
            let
                snake =
                    case Json.decodeString messageDecoder str of
                        Ok val ->
                            val

                        Err err ->
                            let
                                _ =
                                    Debug.log "Invalid socket message" err
                            in
                                model.snake
            in
                { model | snake = snake } ! [ WebSocket.send "ws://localhost:5000/hello" str ]

        _ ->
            model ! []


messageDecoder : Decoder (List Point)
messageDecoder =
    Json.list
        (Json.map2 Point
            (Json.field "x" Json.int)
            (Json.field "y" Json.int)
        )
