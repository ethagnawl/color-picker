import Html exposing (text, div)
import Html.Attributes exposing (style)
import Html.Events exposing (..)

options = ["rgb(255, 0, 0)",
           "rgb(0, 128, 0)",
           "rgb(0, 0, 255)"]

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
    options' = div [] (List.map option' options)
    prompt = if guess == "" then "Pick a color!" else ""
    rightOrWrong = if guess /= "" then
                     if guess == answer then "Right!" else "Wrong!"
                   else
                     ""
  in
    div
      []
      [
        answer',
        options',
        div [] [text prompt],
        div [] [text rightOrWrong]
      ]

inbox =
  Signal.mailbox ""

guess =
  inbox.signal

answer = "rgb(255, 0, 0)"

main =
  Signal.map (view inbox.address answer) guess
