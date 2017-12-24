module Widgets exposing (..)

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
    , pixels : Maybe Int
    , portion : Maybe Int
    , percent : Maybe Float
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
                    , children = []
                    }
            )


newLength : Length
newLength =
    { style = Fill
    , pixels = Nothing
    , portion = Nothing
    , percent = Nothing
    }
