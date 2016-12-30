module Main exposing (..)

import Html exposing (div, button, text, img)
import Html.Events exposing (onClick, on)
import Html.Attributes exposing (src)
import Json.Decode as JD


main : Program Never Model Action
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


largeImageSrc : String
largeImageSrc =
    "http://i.imgur.com/3z6ToXl.jpg?rand=123"


type alias Model =
    { message : String
    , imageUrl : Maybe String
    }


init : ( Model, Cmd Action )
init =
    ( Model "The image has not yet been loaded" Nothing, Cmd.none )


type Action
    = NoOp
    | LoadImage String
    | ImageLoaded String


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        LoadImage imgsrc ->
            ( { model | message = "Loading Image: " ++ imgsrc, imageUrl = Just imgsrc }, Cmd.none )

        ImageLoaded imgsrc ->
            ( { model | message = "Image has been loaded: " ++ imgsrc }, Cmd.none )


view : { a | imageUrl : Maybe String, message : String } -> Html.Html Action
view model =
    let
        showImage =
            case model.imageUrl of
                Just imgsrc ->
                    img
                        [ src imgsrc
                        , onLoadSrc ImageLoaded
                        ]
                        []

                Nothing ->
                    text "No image to display"
    in
        div []
            [ div [] [ text model.message ]
            , button [ onClick (LoadImage largeImageSrc) ] [ text "Click to load image" ]
            , showImage
            ]


onLoadSrc : (String -> msg) -> Html.Attribute msg
onLoadSrc tagger =
    on "load" (JD.map tagger targetSrc)


targetSrc : JD.Decoder String
targetSrc =
    JD.at [ "target", "src" ] JD.string
