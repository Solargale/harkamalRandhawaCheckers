module Main where

import Moves
import Checkers.FrontEnd.Basic
import Checkers.FrontEnd.Types
import Checkers.Types (initialGameState)

gameConfig :: GameConfig
gameConfig = GameConfig{
    engine = apply_move,
    blackMove = Human,
    redMove = Human,
    state = initialGameState
}


main :: IO ()
main = do
      print (moves initialGameState)
      frontend gameConfig {
        engine = apply_move,
        blackMove = Human,
        redMove = Human,
        state = initialGameState
      }
