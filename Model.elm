module Model (GameState(Pre, In, Post), GameObject, initialGameObject) where

type GameState = Pre | In | Post

type alias GameObject = {
  gameState: GameState,
  initials : String,
  initialsSaved : Bool,
  answer : String,
  options : List String,
  guess : Maybe String,
  score : Int,
  rounds : Int,
  gameOver : Bool
}

initialGameObject : GameObject
initialGameObject = {
    gameState = Pre,
    initials = "",
    initialsSaved = False,
    answer = "rgb(0, 0, 0)",
    options = ["rgb(0, 0, 0)"],
    guess = Nothing,
    score = 0,
    rounds = 0,
    gameOver = False
  }
