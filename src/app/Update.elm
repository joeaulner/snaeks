module Update exposing (subscriptions, update)

import Char
import Time exposing (millisecond)
import Random
import Keyboard exposing (KeyCode)
import Extra.List as List
import Model exposing (Model, Msg(..), Vector, Direction(..), Point, UserAction(..), Snake, worldSize)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every (125 * millisecond) (\x -> Tick)
        , Keyboard.presses (UserInput << actionFromKeycode)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    if model.started then
        case msg of
            Tick ->
                moveSnake model ! [ spawnFood model ]

            SpawnFood ( x, y ) ->
                { model | food = Just <| Point x y } ! []

            UserInput action ->
                case action of
                    NoOp ->
                        model ! []

                    ChangeDirection direction ->
                        { model | snake = changeDirection direction model.snake } ! []

                    Reset ->
                        Model.init

                    _ ->
                        model ! []
    else
        case msg of
            UserInput Start ->
                { model | started = True } ! []

            _ ->
                model ! []


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
                if model.collision then
                    model
                else if collision rest head_ then
                    { model | collision = True }
                else if foodCollision model.food head_ then
                    { model | food = Nothing, snake = head_ :: head :: rest }
                else
                    { model | snake = head_ :: head :: List.dropTail 1 rest }


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


collision : List Vector -> Vector -> Bool
collision vectors { x, y } =
    let
        hitWall =
            x >= worldSize || x < 0 || y >= worldSize || y < 0

        hitSelf =
            List.any (\v -> x == v.x && y == v.y) vectors
    in
        hitWall || hitSelf


foodCollision : Maybe Point -> Vector -> Bool
foodCollision food head =
    case food of
        Nothing ->
            False

        Just { x, y } ->
            x == head.x && y == head.y


spawnFood : Model -> Cmd Msg
spawnFood model =
    if (model.food == Nothing) then
        Random.pair (Random.int 1 30) (Random.int 1 30)
            |> Random.generate SpawnFood
    else
        Cmd.none


changeDirection : Direction -> Snake -> Snake
changeDirection direction snake =
    case snake of
        [] ->
            snake

        _ :: [] ->
            snake

        head :: next :: rest ->
            let
                direction_ =
                    preventReverse direction head next
            in
                { head | d = direction_ } :: next :: rest


preventReverse : Direction -> Vector -> Vector -> Direction
preventReverse direction head next =
    case direction of
        North ->
            if head.y + 1 == next.y then
                head.d
            else
                North

        East ->
            if head.x + 1 == next.x then
                head.d
            else
                East

        South ->
            if head.y - 1 == next.y then
                head.d
            else
                South

        West ->
            if head.x - 1 == next.x then
                head.d
            else
                West


actionFromKeycode : KeyCode -> UserAction
actionFromKeycode keycode =
    case Char.fromCode keycode of
        'w' ->
            ChangeDirection North

        'd' ->
            ChangeDirection East

        's' ->
            ChangeDirection South

        'a' ->
            ChangeDirection West

        ' ' ->
            Start

        '\x0D' ->
            Reset

        _ ->
            NoOp
