module Moves where

import Checkers.Types

-- Implement your code for moves function below
apply_move:: Move -> GameState -> GameState
apply_move mv st = st{message = "!!GAME OVER!!"}

moves :: GameState -> ([Move],[Move])
moves g = (simple_moves g,jump_moves g)

simple_moves :: GameState -> [Move]
simple_moves g = []

jump_moves :: GameState -> [Move]
jump_moves g = []