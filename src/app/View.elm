module View exposing (view)

import Html exposing (Html)
import Html.Attributes as Html
import Svg exposing (Svg, Attribute)
import Svg.Attributes as Svg
import Model exposing (Model, Msg, Snake, Vector, worldSize)


githubImageSrc : String
githubImageSrc =
    "https://camo.githubusercontent.com/e7bbb0521b397edbd5fe43e7f760759336b5e05f/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677265656e5f3030373230302e706e67"


tileWidth : Int
tileWidth =
    14


view : Model -> Html Msg
view model =
    let
        dim =
            (worldSize * tileWidth) |> toString

        -- adding stylesheet to body for now to keep build simple
        stylesheet =
            Html.node "link"
                [ Html.attribute "rel" "stylesheet"
                , Html.attribute "property" "stylesheet"
                , Html.attribute "href" "styles/main.css"
                ]
                []
    in
        Html.div [ Html.class "content" ]
            [ stylesheet
            , Html.a [ Html.href "https://github.com/pancakeCaptain/snaeks", Html.target "_blank", Html.rel "noopener" ]
                [ Html.img [ Html.class "github-image", Html.src githubImageSrc, Html.alt "Fork me on GitHub" ] []
                ]
            , Html.div []
                [ Html.h1 [] [ Html.text "Welcome to Snæks!" ]
                , Html.div [ Html.class "instructions" ]
                    [ Html.div [] [ Html.text "Use WASD to move" ]
                    , Html.div [] [ Html.text "Press [Space] to start" ]
                    , Html.div [] [ Html.text "Press [Enter] to reset" ]
                    ]
                ]
            , Svg.svg
                [ Svg.height dim
                , Svg.width dim
                , Svg.viewBox <| "0 0 " ++ dim ++ " " ++ dim
                ]
                [ map, gameObjects model ]
            ]


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
