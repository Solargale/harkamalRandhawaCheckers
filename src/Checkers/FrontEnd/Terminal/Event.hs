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
handleTuiEvent s = case s^. configL . stateL . statusL of
  GameOver -> gameOverTuiEvent s
  Turn x  -> case s^. configL . turnLens x of
                Human -> humanTuiEvent s
                Ai f  -> cpuTuiEvent $  moveL .~ aiMove $ s
                  where aiMove = f (s^.configL.stateL)

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
        EvKey KEnter [] -> continue $ resetMove $ set kingL False $ moveFun s
          where
            moveFun = over (configL . stateL) ((s^.configL.engineL) (s^.moveL))
            resetMove = set moveL []

        EvKey (KChar ' ') [] -> continue $ over moveL addPiece $ over kingL kingCheck s
          where
            x :: Coord
            x = accessCursor $ view boardL s
            addPiece :: Move -> Move
            addPiece l = l ++ [if kingCheck (s^.kingL) then K x else P x]
            kingCheck :: Bool -> Bool
            kingCheck t = case (s^.moveL, s^.configL.stateL.statusL, x) of
              -- started by choosing a king
              ([], Turn Black, _)    -> x `elem` s^.configL.stateL.blackKingsL
              ([], Turn Red, _)      -> x `elem` s^.configL.stateL.redKingsL
              -- landed on the edge of the board, becoming a king
              (_, Turn Red, (_, 0))  -> True 
              (_, Turn Black, (_,7)) -> True 
              -- neither trigger happens, keep state same.
              _                      -> t
        _ -> continue s
    _ -> continue s

