module Widgets exposing (..)

import Element exposing (Attribute)
import Element.Attributes as Attributes
import Unique exposing (Unique)


type alias Id =
    Unique.Id


type LengthStyle
    = Fill
    | FillPortion
    | Pixels
    | Percent
    | Content


type alias Length =
    { style : LengthStyle
    , pixels : Float
    , portion : Int
    , percent : Float
    }


type WidgetElement
    = Row
    | Column


type Widget
    = Widget WidgetProperties


type alias WidgetProperties =
    { id : Unique.Id
    , element : WidgetElement
    , width : Length
    , height : Length
    , children : List Widget
    }


width (Widget w) =
    w.width


type alias WidgetGen =
    Unique Widget


update : Id -> WidgetGen -> (WidgetProperties -> WidgetProperties) -> WidgetGen
update id widget fn =
    let
        updateWidget (Widget w) =
            if id == w.id then
                Widget (fn w)
            else
                Widget { w | children = List.map updateWidget w.children }
    in
        Unique.run widget
            |> updateWidget
            |> Unique.return


updateStyle : LengthStyle -> Length -> Length
updateStyle style length =
    { length | style = style }


new : WidgetElement -> WidgetGen
new el =
    Unique.unique
        |> Unique.map
            (\id ->
                Widget
                    { id = id
                    , element = el
                    , width = newLength
                    , height = newLength
                    , children = []
                    }
            )


newLength : Length
newLength =
    { style = Fill
    , pixels = 300
    , portion = 1
    , percent = 100
    }


lengthToAttr : Length -> Attributes.Length
lengthToAttr length =
    case length.style of
        Fill ->
            Attributes.fill

        FillPortion ->
            Attributes.fillPortion length.portion

        Pixels ->
            Attributes.px length.pixels

        Percent ->
            Attributes.percent length.percent

        Content ->
            Attributes.fill
