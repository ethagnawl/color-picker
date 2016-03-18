import Html exposing (text, div)
import Html.Attributes exposing (style)
import Html.Events exposing (..)

type alias Model =
  {
    options : List String
  }

model = Model ["rgb(255, 0, 0)", "rgb(0, 128, 0)", "rgb(0, 0, 255)"]

option address color =
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
    option' = option address
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

inbox =
  Signal.mailbox ""

guess =
  inbox.signal

answer = Maybe.withDefault "rgba(0, 0, 0)" (List.head model.options)

main =
  Signal.map (view inbox.address answer) guess
