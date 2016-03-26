module Action (Action(..), update) where

import Effects exposing (Effects, Never)
import Model
import Signal

type Action =
    GameObjectReceived Model.GameObject
  | GuessMade String
  | InitialsAdded String
  | InitialsSaved Bool
  | Noop

noFx model =
  (model, Effects.none)

update portRequestNewGameObject action model =
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
        (model,
         Signal.send portRequestNewGameObject.address model
           |> Effects.task
           |> Effects.map (\_ -> Noop))

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
