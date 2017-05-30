module Update exposing (subscriptions, update)

import Time exposing (millisecond)
import Random
import Model exposing (Model, Msg(..), Vector, Direction(..), Point)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every (125 * millisecond) (\x -> Tick)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            moveSnake model ! [ spawnFood model ]

        SpawnFood ( x, y ) ->
            { model | food = Just <| Point x y } ! []


moveSnake : Model -> Model
moveSnake model =
    case model.snake of
        [] ->
            model

        head :: rest ->
            let
                head_ =
                    newHead head
            in
                { model
                    | snake = head_ :: head :: (List.take (List.length rest - 1) rest)
                }


newHead : Vector -> Vector
newHead { x, y, d } =
    let
        ( x_, y_ ) =
            case d of
                North ->
                    ( x, y + 1 )

                East ->
                    ( x + 1, y )

                South ->
                    ( x, y - 1 )

                West ->
                    ( x - 1, y )
    in
        Vector x_ y_ d


spawnFood : Model -> Cmd Msg
spawnFood model =
    if (model.food == Nothing) then
        Random.pair (Random.int 1 30) (Random.int 1 30)
            |> Random.generate SpawnFood
    else
        Cmd.none
