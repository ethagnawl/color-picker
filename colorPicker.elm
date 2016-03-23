module ColorPicker where

import Debug
import Effects exposing (Effects, Never)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (Html, text, div, input, button)
import Maybe exposing (Maybe(Just, Nothing))
import Signal exposing (Address, Signal, Mailbox, mailbox, send)
import StartApp
import Task

optionView address color =
  let
    guessCallback = GuessMade color
  in
    div
      [
        class "option",
        onClick address guessCallback,
        style [
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
        ]]
    []

view address model =
  let
    initialsCallback initials = Signal.message address (InitialsAdded initials)
    initialsView = div
      []
      [
        input
          [
            placeholder "Enter your initials",
            value model.initials,
            on "input" targetValue initialsCallback
          ]
          [],
        button
          [onClick address <| InitialsSaved True]
          [text "Play!"]
      ]
    answer' = answerView model.answer
    options' = div [class "options"] (List.map (optionView address) model.options)
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

type alias GameObject = {
  initials : String,
  initialsSaved : Bool,
  answer : String,
  options : List String,
  guess : String,
  score : Int
}

init = GameObject "" False "rgb(0, 0, 0)" ["rgb(0, 0, 0)"] "" 0

type Action =
    GameObjectReceived GameObject
  | GuessMade String
  | InitialsAdded String
  | InitialsSaved Bool
  | Noop

update action model =
  case action of

    GuessMade newGuess ->
      let
        score = if newGuess == model.answer then
                   if newGuess == model.guess then model.score else (model.score + 5)
                else
                  if model.score - 5 < 0 then 0 else model.score - 5
        model = { model | guess = newGuess,
                          score = score }
      in
        (model, sendNewGameObjectRequest model)

    GameObjectReceived newGameObject ->
      (
        { model | answer = newGameObject.answer,
                  guess = "",
                  options = newGameObject.options,
                  score = model.score }
        , Effects.none
      )

    InitialsAdded newInitials ->
      (
        { model | initials = newInitials }
        , Effects.none
      )

    InitialsSaved _ ->
      (
        { model | initialsSaved = True }
        , Effects.none
      )

    Noop ->
      ( model, Effects.none )

portRequestNewGameObject : Mailbox GameObject
portRequestNewGameObject =
  mailbox init

port requestNewGameObject : Signal GameObject
port requestNewGameObject =
  portRequestNewGameObject.signal

sendNewGameObjectRequest model =
  send portRequestNewGameObject.address model
    |> Effects.task
    |> Effects.map (\_ -> Noop)

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

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

main = app.html
