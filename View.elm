module View where

import Action
import Debug
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (Html, text, div, input, button)
import Json.Decode as Json
import Signal

is13 code =
  if code == 13 then Ok () else Err "Not '13'."

-- stolen from: https://github.com/evancz/elm-todomvc/blob/master/Todo.elm
onEnter address value =
    {- alias for the following:
      on "keydown"
        (Json.customDecoder keyCode is13)
        (\_ -> Signal.message address (Action.InitialsSaved True))
    -}
    on "keydown"
      (Json.customDecoder keyCode is13) (\_ -> Signal.message address value)

initialsView address model =
  let
    inputCallback initials = Signal.message address (Action.InitialsAdded initials)
    clickCallback = Action.InitialsSaved True
  in
    div
      []
      [
        input
          [
            autofocus True
          , placeholder "Enter your initials"
          , value model.initials
          , on "input" targetValue inputCallback
          , onEnter address (Action.InitialsSaved True)

          ]
          [],
        button
          [onClick address clickCallback]
          [text "Play!"]
      ]

optionView address color =
  let
    guessCallback = Action.GuessMade (Just color)
  in
    div
      [
        class "option"
      , onClick address guessCallback
      , style [
          ("border", "1px solid black"),
          ("display", "inline-block"),
          ("padding", "12px"),
          ("width", "33%")
        ]
      ]
      [text color]

optionsView address model =
  div
    [class "options"]
    (List.map (optionView address) model.options)

answerView color =
  div
    [style
      [
        ("background-color", color),
        ("bottom", "0"),
        ("left", "0"),
        ("position", "fixed"),
        ("right", "0"),
        ("top", "0"),
        ("z-index", "-1")
      ]
    ]
    []

scoreView model =
  let
    initials = model.initials
    score = toString model.score
  in
    div
      []
      [text ("player: " ++ initials ++ ", score: " ++ score)]

promptView model =
  let
    prompt = case model.guess of
               Just _ -> ""
               Nothing -> "Pick a color!"
  in
    div
      [class "prompt"]
      [text prompt]

view address model =
  let
    initialsView' = initialsView address model
    answer' = answerView model.answer
    promptView' = promptView model
    optionsView' = optionsView address model
    scoreView' = scoreView model
    debugView = div [] [text ("debug: " ++ model.answer)]
  in
    if model.initialsSaved == False then
      initialsView'
    else
      div
        []
        [
          answer'
        , promptView'
        , optionsView'
        , scoreView'
        , debugView
        ]
