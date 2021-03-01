module Moves where

import Checkers.Types

-- Implement your code for moves function below
apply_move:: CheckersEngine
apply_move mv st = st{message = "!!GAME OVER!!"}

moves :: GameState -> ([Move],[Move])
moves g = ([],[])

simple_moves :: GameState -> [Move]
simple_moves g = []

jump_moves :: GameState -> [Move]
jump_moves g = []