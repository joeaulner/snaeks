module World exposing (World, init, update, view)

import Html exposing (Html)
import Svg exposing (Svg, Attribute)
import Svg.Attributes as Svg
import Json.Decode as Json exposing (Decoder)


-- MODEL


worldSize : Int
worldSize =
    32


init : World
init =
    World []


type alias World =
    { snake : List Point }


type alias Point =
    { x : Int, y : Int }



-- UPDATE


update : String -> World -> World
update json world =
    case Json.decodeString snakeDecoder json of
        Ok snake ->
            { world | snake = snake }

        Err err ->
            let
                _ =
                    Debug.log "Invalid socket message" err
            in
                world


snakeDecoder : Decoder (List Point)
snakeDecoder =
    Json.list
        (Json.map2 Point
            (Json.field "x" Json.int)
            (Json.field "y" Json.int)
        )



-- VIEW


tileWidth : Int
tileWidth =
    14


view : World -> Html msg
view world =
    let
        dim =
            (worldSize * tileWidth) |> toString
    in
        Svg.svg
            [ Svg.height dim
            , Svg.width dim
            , Svg.viewBox <| "0 0 " ++ dim ++ " " ++ dim
            ]
            [ map, gameObjects world ]


square : Int -> List (Attribute msg) -> List (Svg msg) -> Svg msg
square dim attr children =
    let
        dim_ =
            toString dim

        attr_ =
            Svg.width dim_ :: Svg.height dim_ :: attr
    in
        Svg.rect attr_ children


map : Svg msg
map =
    square (worldSize * tileWidth) [ Svg.fill "#3465a4" ] []


gameObjects : World -> Svg msg
gameObjects world =
    Svg.g
        [ "translate(0 " ++ toString (worldSize * tileWidth) ++ ") scale(1, -1)" |> Svg.transform
        ]
        [ snake world ]


snake : World -> Svg msg
snake world =
    List.map (segment "purple") world.snake
        |> Svg.g []


segment : String -> Point -> Svg msg
segment color vector =
    square tileWidth
        [ vector.x * tileWidth |> toString |> Svg.x
        , vector.y * tileWidth |> toString |> Svg.y
        , Svg.fill color
        , Svg.stroke "#eeeeec"
        , Svg.strokeWidth "0.5"
        ]
        []
