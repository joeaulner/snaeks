module View exposing (view)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Model exposing (Model, Msg, Snake, Vector)


worldWidth : Int
worldWidth =
    32


tileWidth : Int
tileWidth =
    14


view : Model -> Html Msg
view model =
    let
        dim =
            (worldWidth * tileWidth) |> toString
    in
        Html.div []
            [ Html.div [] [ Html.text "Welcome to Snæks!" ]
            , svg
                [ height dim
                , width dim
                , viewBox <| "0 0 " ++ dim ++ " " ++ dim
                ]
                [ map, gameObjects model ]
            ]


square : Int -> List (Attribute Msg) -> List (Svg Msg) -> Svg Msg
square dim attr children =
    let
        dim_ =
            toString dim

        attr_ =
            width dim_ :: height dim_ :: attr
    in
        Svg.rect attr_ children


map : Svg Msg
map =
    square (worldWidth * tileWidth) [ fill "#3465a4" ] []


gameObjects : Model -> Svg Msg
gameObjects model =
    g
        [ "translate(0 " ++ toString (worldWidth * tileWidth) ++ ") scale(1, -1)" |> transform
        ]
        [ snake model, food model ]


snake : Model -> Svg Msg
snake model =
    List.map (segment "#cc0000") model.snake
        |> g []


segment : String -> Vector -> Svg Msg
segment color vector =
    square tileWidth
        [ vector.x * tileWidth |> toString |> x
        , vector.y * tileWidth |> toString |> y
        , fill color
        , stroke "#eeeeec"
        , strokeWidth "0.5"
        ]
        []


food : Model -> Svg Msg
food model =
    case model.food of
        Nothing ->
            g [] []

        Just { x, y } ->
            square tileWidth
                [ x * tileWidth |> toString |> Svg.Attributes.x
                , y * tileWidth |> toString |> Svg.Attributes.y
                , fill "orange"
                ]
                []
