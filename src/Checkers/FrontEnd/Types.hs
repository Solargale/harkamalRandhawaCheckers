module Checkers.FrontEnd.Types where

import Checkers.Types

data GameConfig = 
  GameConfig { engine :: CheckersEngine
             , blackMove :: PlayerType
             , redMove :: PlayerType
             , state :: GameState}

-- There will be multiple frontends to this program; from the AI-programmers viewpoint it doesn't matter.
-- In fact, I'd recommend you avoid looking at their source code, as it uses concepts not covered in class.
-- There is simply a frontend type, and it will be 
type FrontEnd = GameConfig -> IO ()
