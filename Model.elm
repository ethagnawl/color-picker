module Model(GameObject, initialGameObject) where

type alias GameObject = {
  initials : String,
  initialsSaved : Bool,
  answer : String,
  options : List String,
  guess : Maybe String,
  score : Int
}

initialGameObject = GameObject "" False "rgb(0, 0, 0)" ["rgb(0, 0, 0)"] Nothing 0
