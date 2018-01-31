module Widgets exposing (..)

import Element exposing (Attribute)
import Element.Attributes as Attributes


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


type Position
    = InMap String
    | Root


type alias WidgetProperties =
    { position : Position
    , element : WidgetElement
    , width : Length
    , height : Length
    , children : List Widget
    }


width (Widget w) =
    w.width


updateWidthStyle : LengthStyle -> Widget -> Widget
updateWidthStyle style (Widget widget) =
    Widget { widget | width = updateStyle style widget.width }


updateHeightStyle : LengthStyle -> Widget -> Widget
updateHeightStyle style (Widget widget) =
    Widget { widget | height = updateStyle style widget.height }


updateStyle : LengthStyle -> Length -> Length
updateStyle style length =
    { length | style = style }


new : WidgetElement -> Position -> Widget
new el position =
    Widget
        { position = position
        , element = el
        , width = newLength
        , height = newLength
        , children = []
        }


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
