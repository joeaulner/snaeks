module Snaeks.View exposing (view)

import Html exposing (Html)
import Html.Attributes as Html
import Svg exposing (Svg, Attribute)
import Svg.Attributes as Svg
import Snaeks.Model exposing (Model, Msg, Snake, Vector, worldSize)


tileWidth : Int
tileWidth =
    14


view : Model -> Html Msg
view model =
    let
        dim =
            (worldSize * tileWidth) |> toString
    in
        Svg.svg
            [ Svg.height dim
            , Svg.width dim
            , Svg.viewBox <| "0 0 " ++ dim ++ " " ++ dim
            ]
            [ map, gameObjects model ]


square : Int -> List (Attribute Msg) -> List (Svg Msg) -> Svg Msg
square dim attr children =
    let
        dim_ =
            toString dim

        attr_ =
            Svg.width dim_ :: Svg.height dim_ :: attr
    in
        Svg.rect attr_ children


map : Svg Msg
map =
    square (worldSize * tileWidth) [ Svg.fill "#3465a4" ] []


gameObjects : Model -> Svg Msg
gameObjects model =
    Svg.g
        [ "translate(0 " ++ toString (worldSize * tileWidth) ++ ") scale(1, -1)" |> Svg.transform
        ]
        [ snake model, food model ]


snake : Model -> Svg Msg
snake model =
    let
        color =
            if model.collision then
                "#cc0000"
            else
                "purple"
    in
        List.map (segment color) model.snake
            |> Svg.g []


segment : String -> Vector -> Svg Msg
segment color vector =
    square tileWidth
        [ vector.x * tileWidth |> toString |> Svg.x
        , vector.y * tileWidth |> toString |> Svg.y
        , Svg.fill color
        , Svg.stroke "#eeeeec"
        , Svg.strokeWidth "0.5"
        ]
        []


food : Model -> Svg Msg
food model =
    case model.food of
        Nothing ->
            Svg.g [] []

        Just { x, y } ->
            square tileWidth
                [ x * tileWidth |> toString |> Svg.x
                , y * tileWidth |> toString |> Svg.y
                , Svg.fill "orange"
                ]
                []
