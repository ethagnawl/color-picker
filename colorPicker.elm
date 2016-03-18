import Html exposing (text, div)
import Html.Attributes exposing (style)
import Html.Events exposing (..)

type alias Model =
  {
    options : List String
  }

model = Model ["rgb(255, 0, 0)", "rgb(0, 128, 0)", "rgb(0, 0, 255)"]

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

view address answer guess =
  let
    answer' = answerView answer
    option' = optionView address
    options' = div [] (List.map option' model.options)
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

guessInbox =
  Signal.mailbox ""

guess =
  guessInbox.signal

answerInbox =
  let
    default = Maybe.withDefault "rgba(0, 0, 0)" (List.head model.options)
  in
    Signal.mailbox default

answer =
  answerInbox.signal

main =
  Signal.map2 (view guessInbox.address) answer guess
