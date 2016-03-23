module ColorPicker where

import Debug
import Effects exposing (Effects, Never)
import Maybe exposing (Maybe(Just, Nothing))
import Signal exposing (Address, Signal, Mailbox, mailbox, send)
import StartApp
import Task
import View

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

noFx : model -> (model, Effects a)
noFx model =
  (model, Effects.none)

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
      noFx { model | answer = newGameObject.answer,
                     guess = "",
                     options = newGameObject.options,
                     score = model.score }

    InitialsAdded newInitials ->
      noFx { model | initials = newInitials }

    InitialsSaved _ ->
      noFx { model | initialsSaved = True }

    Noop ->
      noFx model

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

view address model =
  let
    context = View.Context
      (Signal.forwardTo address (InitialsAdded))
      (Signal.forwardTo address (InitialsSaved))
      (Signal.forwardTo address (GuessMade))
  in
     View.view context model
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
