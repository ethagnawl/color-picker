module Model(GameObject, initialGameObject) where

type alias GameObject = {
    answer : String
  , gameOver : Bool
  , guess : Maybe String
  , initialsSaved : Bool
  , initials : String
  , options : List String
  , rounds : Int
  , score : Int
  }

initialGameObject : GameObject
initialGameObject = {
    answer = "rgb(0, 0, 0)"
  , gameOver = False
  , guess = Nothing
  , initials = ""
  , initialsSaved = False
  , options = ["rgb(0, 0, 0)"]
  , rounds = 0
  , score = 0
  }
