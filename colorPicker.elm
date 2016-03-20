module ColorPicker where

import Debug
import Effects exposing (Effects, Never)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Html exposing (Html, text, div)
import Maybe exposing (Maybe(Just, Nothing))
import Signal exposing (Address, Signal, Mailbox, mailbox, send)
import StartApp
import Task

optionView address color =
  div
    [onClick address <| GuessMade color]
    [text color]

answerView color =
  div
    [style
      [
        ("background-color", color),
        ("height", "100px"),
        ("width", "100px")]]
    []

view address model =
  let
    answer' = answerView model.answer
    options' = div [] (List.map (optionView address) model.options)
    prompt = if model.guess /= "" then "" else "Pick a color!"
    promptView = div [] [text prompt]
    rightOrWrong = if  model.guess /= "" then
                     if model.guess == model.answer then "Right!" else "Wrong!"
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
  options : List String,
  guess : String
}

init = GameObject "rgb(0, 0, 0)" ["rgb(0, 0, 0)"] ""

type Action =
    GameObjectChanged
  | GameObjectReceived GameObject
  | GuessMade String
  | Noop

update action model =
  case action of

    GuessMade newGuess ->
      (
        { model | guess = newGuess }
        , Effects.none
      )

    GameObjectReceived newGameObject ->
      (
        { model | answer = newGameObject.answer,
                  options = newGameObject.options }
        , Effects.none
      )

    -- request new colors via outgoing port
    GameObjectChanged ->
      Debug.crash "GameObjectChanged"
      ( model, Effects.none )

    Noop ->
      Debug.crash "Noop"
      ( model, Effects.none )

port options : Signal GameObject

incomingGameObject : Signal Action
incomingGameObject =
  Signal.map GameObjectReceived options

app =
  StartApp.start {
    init = (init, Effects.none),
    view = view,
    update = update,
    inputs = [incomingGameObject]
  }

main = app.html
