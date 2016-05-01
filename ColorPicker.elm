module ColorPicker where

import Action
import Debug
import Effects exposing (Effects, Never)
import Maybe exposing (Maybe(Just, Nothing))
import Model
import Signal exposing (Address, Signal, Mailbox, mailbox, send)
import StartApp
import Task
import View

portRequestNewGameObject : Mailbox Model.GameObject
portRequestNewGameObject =
  mailbox Model.initialGameObject

port requestNewGameObject : Signal Model.GameObject
port requestNewGameObject =
  portRequestNewGameObject.signal

port options : Signal Model.GameObject

incomingGameObject : Signal Action.Action
incomingGameObject =
  Signal.map Action.GameObjectReceived options

view address model =
   View.view address model

update =
  -- Make portRequestNewGameObject available for use in update::GuessMade.
  -- This is definitely a bit of a hack. A better approach would be to move
  -- these common mailboxes into a Utility module.
  -- Color would import `portRequestNewGameObject.signal` when creating the
  --`requestNewGameObject` port and Action would import
  -- `portRequestNewGameObject.address` for use in update::GuessMade.
  Action.update portRequestNewGameObject

app =
  StartApp.start {
    init = (Model.initialGameObject, Effects.none)
  , inputs = [incomingGameObject]
  , update = update
  , view = view
  }

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

main =
  app.html
