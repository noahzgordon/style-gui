module Main exposing (main)

import Html exposing (Html)
import Color exposing (..)
import Style exposing (..)
import Style.Color exposing (background)
import Style.Border as Border
import Style.Shadow as Shadow
import Element exposing (..)
import Element.Input as Input exposing (radio, choice, labelAbove)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Dict exposing (Dict)
import Debug
import Widgets exposing (Widget(..), Position(..))


-- model


type Menu
    = Props Widgets.WidgetProperties


type alias Model =
    { widgetMap : Dict String Widget
    , rootWidget : Widget
    , menu : Maybe Menu
    }


init =
    ( { widgetMap = Dict.empty
      , rootWidget = Widgets.new Widgets.Row Root
      , menu = Nothing
      }
    , Cmd.none
    )



-- update


type Message
    = CloseMenu
    | OpenMenu Menu
    | SetWidgetWidthStyle Position Widgets.LengthStyle
    | SetWidgetHeightStyle Position Widgets.LengthStyle
    | SetWidgetWidthPixels Position String


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        OpenMenu menu ->
            ( { model | menu = Just menu }, Cmd.none )

        CloseMenu ->
            ( { model | menu = Nothing }, Cmd.none )

        SetWidgetWidthStyle position widthStyle ->
            case position of
                Root ->
                    ( { model | rootWidget = Widgets.updateWidthStyle widthStyle model.rootWidget }
                    , Cmd.none
                    )

                InMap id ->
                    ( { model | widgetMap = Dict.update id (Maybe.map (Widgets.updateWidthStyle widthStyle)) model.widgetMap }
                    , Cmd.none
                    )

        SetWidgetHeightStyle position heightStyle ->
            case position of
                Root ->
                    ( { model | rootWidget = Widgets.updateHeightStyle heightStyle model.rootWidget }
                    , Cmd.none
                    )

                InMap id ->
                    ( { model | widgetMap = Dict.update id (Maybe.map (Widgets.updateHeightStyle heightStyle)) model.widgetMap }
                    , Cmd.none
                    )

        SetWidgetWidthPixels position newPixelString ->
            let
                updateFn (Widget w) =
                    let
                        oldWidth =
                            w.width

                        newWidth =
                            { oldWidth
                                | pixels =
                                    String.toFloat newPixelString
                                        |> Result.withDefault oldWidth.pixels
                            }
                    in
                        Widget { w | width = newWidth }
            in
                case position of
                    Root ->
                        ( { model | rootWidget = updateFn model.rootWidget }
                        , Cmd.none
                        )

                    InMap id ->
                        ( { model | widgetMap = Dict.update id (Maybe.map updateFn) model.widgetMap }
                        , Cmd.none
                        )



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
    viewport styles
        <| column None
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
                    row None []
                        <| [ radio None []
                                <| { onChange = SetWidgetWidthStyle widget.position
                                   , selected = Just widget.width.style
                                   , label = labelAbove (text "Width")
                                   , options = []
                                   , choices =
                                        [ choice Widgets.Pixels (text "Pixels")
                                        , choice Widgets.Fill (text "Fill")
                                        , choice Widgets.FillPortion (text "Fill Portion")
                                        , choice Widgets.Percent (text "Percent")
                                        , choice Widgets.Content (text "Stretch to Content")
                                        ]
                                   }
                           , when (widget.width.style == Widgets.Pixels)
                                <| el None []
                                <| Input.text None
                                    []
                                    { onChange = SetWidgetWidthPixels widget.position
                                    , value = toString widget.width.pixels
                                    , label = labelAbove (text "Px")
                                    , options = []
                                    }
                           , radio None []
                                <| { onChange = SetWidgetHeightStyle widget.position
                                   , selected = Just widget.height.style
                                   , label = labelAbove (text "Height")
                                   , options = []
                                   , choices =
                                        [ choice Widgets.Pixels (text "Pixels")
                                        , choice Widgets.Fill (text "Fill")
                                        , choice Widgets.FillPortion (text "Fill Portion")
                                        , choice Widgets.Percent (text "Percent")
                                        , choice Widgets.Content (text "Stretch to Content")
                                        ]
                                   }
                           ]
    in
        Element.modal MenuStyle [ height fill, width fill ]
            <| column None [ height fill ]
            <| [ row None [ height (px 100), alignRight, padding 30 ]
                    <| [ el Button [ verticalCenter, padding 10, onClick CloseMenu ] (text "close") ]
               , content
               ]


previewPane model =
    column None
        [ height (fillPortion 1), width (fillPortion 2) ]
        [ Element.text "Preview", renderWidget model.rootWidget ]


defaultWidgetProps =
    { width = Widgets.Fill }


renderWidget : Widgets.Widget -> Element Style v Message
renderWidget (Widget w) =
    case w.element of
        Widgets.Row ->
            row WidgetDefault
                [ Widgets.lengthToAttr w.height |> height
                , Widgets.lengthToAttr w.width |> width
                , onClick (OpenMenu (Props w))
                ]
                (List.map renderWidget w.children)

        Widgets.Column ->
            column WidgetDefault [] (List.map renderWidget w.children)


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
