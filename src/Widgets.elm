module Widgets exposing (..)


type Widget
    = Row (List Widget)
    | Column (List Widget)
