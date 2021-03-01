module Checkers.FrontEnd.Terminal.Draw where

-- Brick
import Brick.AttrMap
import Brick.Main
import Brick.Types
import Brick.Util

import qualified Brick.Widgets.Border as B
import qualified Brick.Widgets.Center as C
import qualified Brick.Widgets.Border.Style as BS
import Brick.Widgets.Core
import Brick.Widgets.Border
import Graphics.Vty.Input.Events
import Graphics.Vty.Attributes

import qualified Graphics.Vty as V


import qualified Data.List.NonEmpty as NE
import Data.List.NonEmpty (NonEmpty(..), toList)

-- non-Empty cursor
import Cursor.Simple.List.NonEmpty

-- Lenses
import Lens.Micro
import Lens.Micro.Extras

-- Local pieces
import Checkers.Types
import Checkers.FrontEnd.Terminal.Types



{-
    Drawing
-}
drawTui :: TuiState -> [Widget ResourceName]
drawTui s = case view (configL . stateL . statusL) s of
  GameOver -> drawGameOverUI $ view (configL . stateL . messageL) s
  _ -> drawGameUI s

drawGameUI :: TuiState -> [Widget ResourceName]
drawGameUI s =
  [ C.center $ padRight (Pad 2) (drawStats s) <=> drawGrid s ]

drawGameOverUI :: String -> [Widget ResourceName]
drawGameOverUI s = [ withBorderStyle BS.unicodeBold
                     $ B.borderWithLabel (str "Game Mode")
                     $ vBox [ withAttr plain $ str $ s
                            , withAttr plain $ str $
                              "Press n for a new game, q to quit"]]


drawGrid :: TuiState -> Widget ResourceName
drawGrid s = withBorderStyle BS.unicodeBold
  $ B.borderWithLabel (str "Draughts")
  $ vBox [hBox [drawSquare s cursor square | square <- row] | row <- gameBoard]
  where
    cursor = nonEmptyCursorCurrent $ nonEmptyCursorCurrent $ board s
    ctl = NE.toList . rebuildNonEmptyCursor
    gameBoard = map ctl $ ctl $ board s

drawStats :: TuiState -> Widget ResourceName
drawStats s = withBorderStyle BS.unicodeBold
  $ B.borderWithLabel (str "Game Info")
  $ vBox   [ msgRow
           , statusRow
           , kingRow
           , moveRow ]
  where
    msgRow = withAttr plain $ str $ view (configL . stateL . messageL) s
    statusRow = withAttr plain $ str $ show (s^. configL . stateL . statusL)
    kingRow = withAttr plain $ str $ "King activated: " ++ show (s^.kingL)
    moveRow = withAttr plain $ str $ show $  view moveL s


{-
Each square is represented by a 3x3 grid.
The bottom square is solid, and only depends even/odd.
The middle square may have a piece (king or piece), which is displayed as a red/black square.
The top is the same, its just whether or not there is a king.
-}

drawSquare :: TuiState -> Coord -> Coord -> Widget ResourceName
drawSquare s cursor xy = vBox [ hBox [o,t,o]
                              , hBox [o,m,o]
                              , hBox [o,o,o] ]
    where
        o = drawOuterBlock cursor xy
        t = drawTopBlock s cursor xy
        m = drawCenterBlock s cursor xy

-- threeBlock :: String
-- threeBlock = block ++ block ++ block

drawOuterBlock :: Coord -> Coord -> Widget ResourceName
drawOuterBlock cursor xy = case (cursor == xy, isEven xy) of
  (True, True) -> withAttr evenSel $ str $ block
  (True, False) -> withAttr oddSel $ str $ block
  (False, True) ->  withAttr  evenBlock $ str $ block
  (False, False) -> withAttr oddBlock $ str $ block

drawCenterBlock :: TuiState -> Coord -> Coord -> Widget ResourceName
drawCenterBlock s b c
  | c `elem` red = withAttr redPiece $ str $ block
  | c `elem` black = withAttr blackPiece $ str $ block
  | otherwise = drawOuterBlock b c
    where
      red = (view (configL . stateL . redPiecesL) s) ++ (view (configL . stateL . redKingsL) s)
      black = (view (configL . stateL . blackPiecesL) s) ++ (view (configL . stateL . blackKingsL) s)

drawTopBlock :: TuiState -> Coord -> Coord -> Widget ResourceName
drawTopBlock s b c
  | c `elem` red = withAttr redPiece $ str $ block
  | c `elem` black = withAttr blackPiece $ str $ block
  | otherwise = drawOuterBlock b c
    where
      red = (view (configL . stateL . redKingsL) s)
      black = (view (configL . stateL . blackKingsL) s)

block :: String
block = "   "

-- Basic helper function
isEven :: Coord -> Bool
isEven (x,y) = (mod (x+y) 2) == 0



{-
    Attributes
-}
theAttributes :: AttrMap
theAttributes = attrMap V.defAttr
  [(evenBlock, V.green `on` V.brightBlue)
  ,(oddBlock, V.green `on` V.white)
  ,(evenSel,  V.green `on` V.brightCyan)
  ,(oddSel, V.green `on` V.brightWhite)
  ,(redPiece, V.green `on` V.red)
  ,(blackPiece, V.green `on` V.black)
  ,(plain, V.black `on` V.white)]

-- Empty squares
evenBlock, oddBlock, evenSel, oddSel, redPiece, blackPiece :: AttrName
evenBlock = attrName "evenBlock"
oddBlock = attrName "oddBlock"
evenSel = attrName "evenSel"
oddSel = attrName "oddSel"
redPiece = attrName "redPiece"
blackPiece = attrName "blackPiece"
-- Squares with pieces

plain :: AttrName
plain = attrName "plain"
