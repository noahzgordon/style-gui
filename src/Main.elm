module Main exposing (main)

import Html exposing (Html)
import Color exposing (..)
import Style exposing (..)
import Style.Color exposing (background)
import Style.Border as Border
import Style.Shadow as Shadow
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Widgets exposing (Widget)


-- model


type Menu
    = Props Widget


type alias Model =
    { gui : Widgets.Widget
    , menu : Maybe Menu
    }


init =
    ( { gui = Widgets.Row []
      , menu = Nothing
      }
    , Cmd.none
    )



-- update


type Message
    = CloseMenu
    | OpenMenu Menu


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        OpenMenu menu ->
            ( { model | menu = Just menu }, Cmd.none )

        CloseMenu ->
            ( { model | menu = Nothing }, Cmd.none )



-- view


type Style
    = None
    | Header
    | Title
    | MainContent
    | WidgetDefault
    | MenuStyle
    | Button


view : Model -> Html Message
view model =
    viewport styles <|
        column None
            [ height fill ]
            [ header, mainContent model, Element.whenJust model.menu menuModal ]


header : Element Style variation Message
header =
    row Header
        [ width (percent 100), height (px 100), center ]
        [ el Title [ center, verticalCenter ] (Element.text "Style GUI") ]


mainContent : Model -> Element Style variation Message
mainContent model =
    row MainContent
        [ height (fillPortion 1) ]
        [ previewPane model ]


menuModal : Menu -> Element Style variation Message
menuModal menu =
    let
        content =
            case menu of
                Props widget ->
                    row None [] []
    in
        Element.modal MenuStyle [ height fill, width fill ] <|
            column None [ height fill ] <|
                [ row None [ height (px 100), alignRight, padding 30 ] <|
                    [ el Button [ verticalCenter, padding 10, onClick CloseMenu ] (text "close") ]
                , content
                ]


previewPane model =
    column None
        [ height (fillPortion 1), width (fillPortion 2) ]
        [ Element.text "Preview", renderWidget model.gui ]


renderWidget widget =
    case widget of
        Widgets.Row subWidgets ->
            row WidgetDefault [ height (fillPortion 1), width (fillPortion 1), onClick (OpenMenu (Props widget)) ] (List.map renderWidget subWidgets)

        Widgets.Column subWidgets ->
            column WidgetDefault [] (List.map renderWidget subWidgets)


styles =
    styleSheet
        [ style Header
            [ background black, Style.Color.text white ]
        , style WidgetDefault
            [ Style.Color.border black
            , Border.dotted
            , Border.all 2
            , Style.hover
                [ cursor "pointer"
                , Style.Color.background gray
                , Shadow.simple
                ]
            ]
        , style MenuStyle
            [ background black
            , opacity 0.75
            , Style.Color.text white
            ]
        , style Button
            [ background blue
            , cursor "pointer"
            ]
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
