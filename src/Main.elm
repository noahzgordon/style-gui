module Main exposing (main)

import Html exposing (Html)
import Color exposing (..)
import Style exposing (..)
import Style.Color exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)


-- model


type alias Model =
    ()


init =
    ( (), Cmd.none )



-- update


type Message
    = Noop


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    ( model, Cmd.none )



-- view


type Styles
    = None
    | Header
    | Title
    | MainContent


view : Model -> Html Message
view model =
    layout styles
        <| column None
            []
            [ header, mainContent ]


header =
    row Header
        [ width (percent 100), height (px 100), center ]
        [ el Title [ center, verticalCenter ] (Element.text "Style GUI") ]


mainContent =
    row MainContent [ height (fill 1) ] []


styles =
    styleSheet
        [ style Header
            [ background black, Style.Color.text white ]
        ]



-- subscriptions


subscriptions =
    \_ -> Sub.none



-- main


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
