module Checkers.FrontEnd.Terminal.Event (handleTuiEvent) where

import Brick.Main
import Brick.Types
import Brick.Util
import Graphics.Vty.Input.Events

import Cursor.Simple.List.NonEmpty


import Lens.Micro
import Lens.Micro.Extras

import Checkers.FrontEnd.Terminal.Types
import Checkers.Types
import Checkers.FrontEnd.Types
import Checkers.FrontEnd.Terminal.Cursor
{-
    In case the player is an AI, you get and display the move.
    In case the player is human, you move to the human loop.
-}
handleTuiEvent :: TuiState -> BrickEvent n e -> EventM n (Next TuiState)
handleTuiEvent s = case view (configL . stateL . statusL) s of
  GameOver -> gameOverTuiEvent s
  Turn Red -> case view (configL . redMoveL) s of
                Human -> humanTuiEvent s
                Ai f -> cpuTuiEvent $ set moveL  (f (s^.configL.stateL)) s
  Turn Black -> case view (configL . redMoveL) s of
                Human -> humanTuiEvent s
                Ai f -> cpuTuiEvent $ set moveL  (f (s^.configL.stateL)) s 

gameOverTuiEvent :: TuiState -> BrickEvent n e -> EventM n (Next TuiState)
gameOverTuiEvent s e =
  case e of
    VtyEvent vtye ->
      case vtye of
        EvKey (KChar 'q') [] -> halt s
        -- EvKey (KChar 'n') [] ->
        --     continue $ buildInitialState --?
        --                  (view redMove s)
        --                  (view blackMove s)
        --                  (view moveLogic s)
        --                  initialGameState
        _ -> continue s
    _ -> continue s

cpuTuiEvent :: TuiState -> BrickEvent n e -> EventM n (Next TuiState)
cpuTuiEvent s e =
  case e of
    VtyEvent vtye ->
      case vtye of
        EvKey (KChar 'q') [] -> halt s
        EvKey KEnter [] ->
          continue $ set moveL [] $ over (configL . stateL) ((s^.configL.engineL) (s^.moveL)) s                  
        _ -> continue s
    _ -> continue s

humanTuiEvent :: TuiState -> BrickEvent n e -> EventM n (Next TuiState)
humanTuiEvent s e =
  case e of
    VtyEvent vtye ->
      case vtye of
        EvKey (KChar 'q') [] -> halt s
        EvKey KRight [] -> continue $ over boardL moveRight s
        EvKey KLeft [] -> continue $ over boardL moveLeft s
        EvKey KDown [] -> case nonEmptyCursorSelectNext (view boardL s)  of
                            Nothing -> continue s
                            Just s' -> continue $ set boardL s' s
        EvKey KUp [] -> case nonEmptyCursorSelectPrev (view boardL s) of
                            Nothing -> continue s
                            Just s' -> continue $ set boardL s' s
        EvKey KEnter [] -> continue $ resetMove $ moveFun s
          where
            moveFun = over (configL . stateL) ((s^.configL.engineL) (s^.moveL))
            resetMove = set moveL []
        EvKey (KChar 'p') [] -> continue $ over moveL (\l -> l ++ [P x]) s
          where
            x = accessCursor $ view boardL s        
        EvKey (KChar 'k') [] -> continue $ over moveL (\l -> l ++ [K x]) s
          where
            x = accessCursor $ view boardL s
        _ -> continue s
    _ -> continue s
