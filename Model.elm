module Model(GameObject, initialGameObject) where

type alias GameObject = {
  initials : String,
  initialsSaved : Bool,
  answer : String,
  options : List String,
  guess : Maybe String,
  score : Int,
  rounds: Int
}

initialGameObject : GameObject
initialGameObject = {
    initials = "",
    initialsSaved = False,
    answer = "rgb(0, 0, 0)",
    options = ["rgb(0, 0, 0)"],
    guess = Nothing,
    score = 0,
    rounds = 0
  }
