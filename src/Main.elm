module Main exposing (main)

import Html exposing (Html, text)


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


view : Model -> Html Message
view model =
    text "Hello world!"


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
