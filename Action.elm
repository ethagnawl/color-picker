module Action (Action(..), update) where

import Debug
import Effects exposing (Effects, Never)
import Model
import Signal
import Task

type Action =
    GameObjectReceived Model.GameObject
  | GameOver Model.GameObject
  | GuessMade (Maybe String)
  | InitialsAdded String
  | InitialsSaved Bool
  | Noop

noFx model =
  (model, Effects.none)

update portRequestNewGameObject action model =
  case action of

    GameObjectReceived newGameObject ->
      let
          -- Inspired by Sidekiq's incremental retry algo:
          -- https://github.com/mperham/sidekiq/blob/35a7962093040784b48498e012bdff380ef991a8/lib/sidekiq/middleware/server/retry_jobs.rb#L178
          sleep = 10000 - (1 ^ 4) + (222 * -(model.rounds))
          model = {   model | answer = newGameObject.answer,
                      guess = Nothing,
                      options = newGameObject.options,
                      gameOver = False,
                      score = model.score }
      in
        (model,
         Task.sleep sleep
           |> Effects.task
           |> Effects.map (always <| GameOver model))

    GameOver oldModel ->
      let
        -- TODO: figure out a way to incorporate a FSM to handle game state
        gameOver = (model.initialsSaved && model.rounds == oldModel.rounds)
      in
        noFx { model | gameOver = gameOver }

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

    InitialsAdded newInitials ->
      noFx { model | initials = newInitials }

    InitialsSaved _ ->
      noFx { model | initialsSaved = True }

    Noop ->
      noFx model
