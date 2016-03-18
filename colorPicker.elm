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

view address options answer guess =
  let
    answer' = answerView answer
    option' = optionView address
    options' = div [] (List.map option' options)
    prompt = if guess == "" then "Pick a color!" else ""
    promptView = div [] [text prompt]
    rightOrWrong = if guess /= "" then
                     if guess == answer then "Right!" else "Wrong!"
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

port options : Signal (List String)

guessInbox =
  Signal.mailbox ""

guess =
  guessInbox.signal

answerInbox =
  let
    default = "rgb(255, 0, 0)"
  in
    Signal.mailbox default

answer =
  answerInbox.signal

main =
  Signal.map3 (view guessInbox.address) options answer guess
