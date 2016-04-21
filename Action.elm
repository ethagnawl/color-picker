module Action (Action(..), update) where

import Effects exposing (Effects, Never)
import Model
import Signal

type Action =
    GameObjectReceived Model.GameObject
  | GuessMade (Maybe String)
  | InitialsAdded String
  | InitialsSaved Bool
  | Noop

noFx model =
  (model, Effects.none)

update portRequestNewGameObject action model =
  case action of

    GuessMade maybeNewGuess ->
      case maybeNewGuess of
        Just newGuess ->
          let
            scoreStep = 5
            score = if newGuess == model.answer then
                      (+) model.score scoreStep
                    else
                      if model.score < scoreStep then
                        0
                      else
                        (-) model.score scoreStep
            model = { model | guess = Just newGuess,
                              rounds = model.rounds + 1,
                              score = score }
          in
            (model,
              Signal.send portRequestNewGameObject.address model
                |> Effects.task
                |> Effects.map (\_ -> Noop))
        Nothing ->
          Debug.crash "This should never happen during a real game."
          (model, Effects.none)

    GameObjectReceived newGameObject ->
      noFx { model | answer = newGameObject.answer,
                     guess = Nothing,
                     options = newGameObject.options,
                     score = model.score }

    InitialsAdded newInitials ->
      noFx { model | initials = newInitials }

    InitialsSaved _ ->
      noFx { model | initialsSaved = True }

    Noop ->
      noFx model
