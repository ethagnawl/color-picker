module ColorPicker where

import Html exposing (text, div)
import Html.Attributes exposing (style)
import Html.Events exposing (..)

optionView address color =
  div
    [onClick address color]
    [text color]

answerView color =
  div
    [style
      [
        ("background-color", color),
        ("height", "100px"),
        ("width", "100px")]]
    []

view address options guess =
  let
    answer' = answerView options.answer
    option' = optionView address
    options' = div [] (List.map option' options.options)
    prompt = if guess == "" then "Pick a color!" else ""
    promptView = div [] [text prompt]
    rightOrWrong = if guess /= "" then
                     if guess == options.answer then "Right!" else "Wrong!"
                   else
                     ""
    rightOrWrongView = div [] [text rightOrWrong]
  in
    div
      []
      [
        answer',
        options',
        promptView,
        rightOrWrongView
      ]

type alias GameObject = {
  answer : String,
  options : List String
}

port options : Signal GameObject

guessInbox =
  Signal.mailbox ""

guess =
  guessInbox.signal

main =
  Signal.map2 (view guessInbox.address) options guess
