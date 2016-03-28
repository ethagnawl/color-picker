module View where

import Debug
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (Html, text, div, input, button)
import Action
import Signal

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

view address model =
  let
    initialsCallback initials = Signal.message address (Action.InitialsAdded initials)
    initialsView = div
      []
      [
        input
          [
              autofocus True
            , placeholder "Enter your initials"
            , value model.initials
            , on "input" targetValue initialsCallback
          ]
          [],
        button
          [onClick address <| Action.InitialsSaved True]
          [text "Play!"]
      ]
    guess' = Maybe.withDefault "" model.guess
    answer' = answerView model.answer
    options' = div [class "options"] (List.map (optionView address) model.options)
    prompt = if guess' /= "" then "" else "Pick a color!"
    promptView = div [class "prompt"] [text prompt]
    rightOrWrong = if  guess' /= "" then
                     if guess' == model.answer then "Right!" else "Wrong!"
                   else
                     ""
    rightOrWrongView = div [] [text rightOrWrong]
    scoreView = div [] [text ("player: " ++ model.initials ++ ", score: " ++ (toString model.score))]
    debugView = div [] [text ("debug: " ++ model.answer)]
  in
    if model.initialsSaved == False then
      div [] [initialsView]
    else
      div
        []
        [
            answer'
          , promptView
          , options'
          , rightOrWrongView
          , scoreView
          , debugView
        ]
