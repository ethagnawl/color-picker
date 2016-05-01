# ABOUT

This is a contrived game (kudos to @timklimowicz for the idea) which was
developed in order to provide a real-time source of data for my [Rails 5
Action Cable
demo](https://github.com/ethagnawl/rails-5-action-cable-elm-docker-demo). The
demo uses [ActionCable](https://github.com/rails/rails/tree/master/actioncable)
to update a list of high scores in real-time.

#TODO
- prevent guess from ever being ""
- use extensible record for GameObject - placeholder values are
  currently sent in on the incomingGameObject port
- use custom types to back interstitial states (game start, round start, round
  over, game over, etc.). the real challenge here is figuring out how to break
  the game object into public and private records (this might also solve the
  previous entry). unfortunately, i can't just stick a gameState field into
  the gameObject because it prevents the options port from typechecking, since
  you can't send custom types over the wire. (using a custom json parser might
  solve this problem).
- consider using different ports for different game actions - everything is currently tunneled over options
