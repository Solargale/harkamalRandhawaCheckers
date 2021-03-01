{-# LANGUAGE RankNTypes #-}
module Checkers.FrontEnd.Terminal.Types where

-- packages
import Lens.Micro
import Lens.Micro.Extras
import Cursor.Simple.List.NonEmpty
-- local
import Checkers.Types
import Checkers.FrontEnd.Types

type Board = NonEmptyCursor (NonEmptyCursor Coord)

data TuiState = TuiState { board :: Board -- handles the state of the cursor
                         , move :: Move -- handles the state of the move being built
                         , king :: Bool
                         , config :: GameConfig}

type ResourceName = String

 {-
  Lenses for TuiState, config.
  This involves manipulating deeply nested data structures, and the use of lenses is more or less unavoidable.
 -}



-- GameState lenses
blackPiecesL :: Lens' GameState [Coord]
blackPiecesL = lens blackPieces (\gamestate newPoint -> gamestate { blackPieces = newPoint })

redPiecesL :: Lens' GameState [Coord]
redPiecesL = lens redPieces (\gamestate newPoint -> gamestate { redPieces = newPoint })

blackKingsL :: Lens' GameState [Coord]
blackKingsL = lens blackKings (\gamestate newPoint -> gamestate { blackKings = newPoint })

redKingsL :: Lens' GameState [Coord]
redKingsL = lens redKings (\gamestate newPoint -> gamestate { redKings = newPoint })

statusL :: Lens' GameState Status
statusL = lens status (\gamestate newPoint -> gamestate { status = newPoint })

messageL :: Lens' GameState String
messageL = lens message (\gamestate newPoint -> gamestate { message = newPoint })

historyL :: Lens' GameState [Move]
historyL = lens history (\gamestate newPoint -> gamestate { history = newPoint })

-- GameConfig lenses

engineL :: Lens' GameConfig CheckersEngine
engineL = lens engine (\gameconfig newPoint -> gameconfig { engine = newPoint })

blackMoveL :: Lens' GameConfig PlayerType
blackMoveL = lens blackMove (\gameconfig newPoint -> gameconfig { blackMove = newPoint })

redMoveL :: Lens' GameConfig PlayerType
redMoveL = lens redMove (\gameconfig newPoint -> gameconfig { redMove = newPoint })

stateL :: Lens' GameConfig GameState
stateL = lens state (\gameconfig newPoint -> gameconfig { state = newPoint })

-- TuiState lenses
-- data TuiState = TuiState { board :: Board -- handles the state of the cursor
--                          , move :: Move -- handles the state of the move being built
--                          , config :: GameConfig}

boardL :: Lens' TuiState Board
boardL = lens board (\tuistate newPoint -> tuistate { board = newPoint })

moveL :: Lens' TuiState Move
moveL = lens move (\tuistate newPoint -> tuistate { move = newPoint })

configL :: Lens' TuiState GameConfig
configL = lens config (\tuistate newPoint -> tuistate { config = newPoint } )

kingL :: Lens' TuiState Bool
kingL = lens king (\tuistate newPoint -> tuistate { king = newPoint } )

{-
    Convenience functions here to cut down on boiler-plate code.
-}

turnLens :: Player -> Lens' GameConfig PlayerType
turnLens Red = redMoveL
turnLens Black = blackMoveL