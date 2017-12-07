module Main exposing (main)

import Html exposing (Html)
import Color exposing (..)
import Style exposing (..)
import Style.Color exposing (..)
import Style.Border as Border
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Dialog
import Widgets exposing (Widget)


-- model


type Menu
    = Props


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


type Styles
    = None
    | Header
    | Title
    | MainContent
    | WidgetDefault


view : Model -> Html Message
view model =
    viewport styles <|
        column None
            [ height (fillPortion 1) ]
            [ header, mainContent model, menuModal model ]


header =
    row Header
        [ width (percent 100), height (px 100), center ]
        [ el Title [ center, verticalCenter ] (Element.text "Style GUI") ]


mainContent model =
    row MainContent
        [ height (fillPortion 1) ]
        [ previewPane model ]


menuModal model =
    Dialog.view (Maybe.map menuConfig model.menu)
        |> Element.html


menuConfig : Menu -> Dialog.Config Message
menuConfig menu =
    let
        baseConfig html =
            { closeMessage = Just CloseMenu
            , containerClass = Nothing
            , header = Nothing
            , body = Just html
            , footer = Nothing
            }
    in
        Html.text "foo"
            |> baseConfig


previewPane model =
    column None
        [ height (fillPortion 1), width (fillPortion 2) ]
        [ Element.text "Preview", renderWidget model.gui ]


renderWidget widget =
    case widget of
        Widgets.Row subWidgets ->
            row WidgetDefault [ height (fillPortion 1), width (fillPortion 1), onClick (OpenMenu Props) ] (List.map renderWidget subWidgets)

        Widgets.Column subWidgets ->
            column WidgetDefault [] (List.map renderWidget subWidgets)


styles =
    styleSheet
        [ style Header
            [ background black, Style.Color.text white ]
        , style WidgetDefault
            [ Style.Color.border black, Border.dotted, Border.all 2 ]
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
