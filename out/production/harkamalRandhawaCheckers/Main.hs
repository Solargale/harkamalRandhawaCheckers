module Main where

import Moves
import Checkers.FrontEnd.Types
import Checkers.Types

testOne :: GameConfig
testOne = GameConfig{
    engine = apply_move,
    blackMove = Human,
    redMove = Human,
    state = GameState {blackPieces = [], redPieces = [], blackKings = [(1,0)], redKings = [(0,3),(2,3)], status = Turn Black, message = "", history = [[K (1,2),K (0,3)],[K (0,1),K (1,0)],[K (0,3),K (1,2)]]}
}

initial :: GameConfig
initial = GameConfig{
    engine = apply_move,
    blackMove = Human,
    redMove = Human,
    state = initialGameState
}


main :: IO ()
main = do
  print (moves GameState {blackPieces = [], redPieces = [], blackKings = [(1,0)], redKings = [(0,3),(2,3)], status = Turn Black, message = "", history = [[K (1,2),K (0,3)],[K (0,1),K (1,0)],[K (0,3),K (1,2)]]})


-- do
--   frontend testOne
