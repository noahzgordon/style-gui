module Main exposing (main)

import Html exposing (Html)
import Color exposing (..)
import Style exposing (..)
import Style.Color exposing (..)
import Style.Border as Border
import Element exposing (..)
import Element.Attributes exposing (..)
import Widgets exposing (Widget)


-- model


type alias Model =
    { gui : Widgets.Widget }


init =
    ( { gui = Widgets.Row [] }, Cmd.none )



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
    | CabinetElement
    | WidgetDefault


view : Model -> Html Message
view model =
    viewport styles <|
        column None
            [ height (fill 1) ]
            [ header, mainContent model ]


header =
    row Header
        [ width (percent 100), height (px 100), center ]
        [ el Title [ center, verticalCenter ] (Element.text "Style GUI") ]


mainContent model =
    row MainContent
        [ height (fill 1) ]
        [ previewPane model, cabinet model ]


previewPane model =
    column None
        [ height (fill 1), width (fill 2) ]
        [ Element.text "Preview", renderWidget model.gui ]


renderWidget widget =
    case widget of
        Widgets.Row subWidgets ->
            row WidgetDefault [ height (fill 1), width (fill 1) ] (List.map renderWidget subWidgets)

        Widgets.Column subWidgets ->
            column WidgetDefault [] (List.map renderWidget subWidgets)


cabinet model =
    column None
        [ height (fill 1), width (fill 1) ]
        [ cabinetElement "Row" Widgets.Row
        , cabinetElement "Column" Widgets.Column
        ]


cabinetElement name widget =
    row (CabinetElement) [ height (px 100), width (fill 1), center, verticalCenter, spacing 20 ] <|
        [ Element.text name ]


styles =
    styleSheet
        [ style Header
            [ background black, Style.Color.text white ]
        , style CabinetElement
            [ background red, Style.Color.text white ]
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
