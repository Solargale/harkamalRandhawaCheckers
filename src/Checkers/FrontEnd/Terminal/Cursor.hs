module Checkers.FrontEnd.Terminal.Cursor where

import Checkers.Types
import Checkers.FrontEnd.Terminal.Types
import qualified Data.List.NonEmpty as NE
import Cursor.Simple.List.NonEmpty
import Data.Maybe
{-
    This is where the functions related to the cursor are stored.
-}
accessCursor :: Board -> Coord
accessCursor = nonEmptyCursorCurrent . nonEmptyCursorCurrent

moveRight :: Board -> Board
moveRight b = case (NE.head list) of
                Nothing -> b
                Just _ -> fromJust $
                  makeNonEmptyCursorWithSelection n $ NE.map fromJust list
  where
    list = NE.map nonEmptyCursorSelectNext $ rebuildNonEmptyCursor b
    n = length $ nonEmptyCursorPrev b

moveLeft :: Board -> Board
moveLeft b = case (NE.head list) of
                Nothing -> b
                Just _ -> fromJust $ makeNonEmptyCursorWithSelection n $ NE.map fromJust list
  where
    list = NE.map nonEmptyCursorSelectPrev $ rebuildNonEmptyCursor b
    n = length $ nonEmptyCursorPrev b

initialBoard :: NonEmptyCursor (NonEmptyCursor Coord)
initialBoard = makeNonEmptyCursor $ NE.fromList
  [ makeNonEmptyCursor $
    NE.fromList [(i,j) | i <- [0..7] ] | j <- [0..7]]
