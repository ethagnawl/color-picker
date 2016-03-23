module View (view, Context) where

import Debug
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (Html, text, div, input, button)
import Signal

type alias Context =
  {
    initialsAdded : Signal.Address String
  , initialsSaved : Signal.Address Bool
  , guessMade : Signal.Address String
  }

optionView address color =
  div
    [
      class "option"
    , onClick address.guessMade color
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

view context model =
  let
    initialsCallback initials = Signal.message context.initialsAdded initials
    initialsView = div
      []
      [
        input
          [
            autofocus True,
            placeholder "Enter your initials",
            value model.initials,
            on "input" targetValue initialsCallback
          ]
          [],
        button
          [onClick context.initialsSaved True]
          [text "Play!"]
      ]
    answer' = answerView model.answer
    options' = div [class "options"] (List.map (optionView context) model.options)
    prompt = if model.guess /= "" then "" else "Pick a color!"
    promptView = div [class "prompt"] [text prompt]
    rightOrWrong = if  model.guess /= "" then
                     if model.guess == model.answer then "Right!" else "Wrong!"
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
          answer',
          promptView,
          options',
          rightOrWrongView,
          scoreView
          , debugView
        ]
