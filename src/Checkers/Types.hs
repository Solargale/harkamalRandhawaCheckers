module Checkers.Types where

import Data.Maybe

type Coord = (Int, Int) -- (x,y), 0-indexed
type Move = [Coord] -- A move is the path determined by your piece.

data Player = Red | Black -- 2 players, red and black
  deriving (Eq, Show)
data Status = Turn Player | GameOver
  deriving (Eq,Show)
-- The status determines whether or not the game is still ongoing
-- Winner Nothing is a tie

-- Gamestate has al of the data for the game.
data GameState =
  GameState { blackPieces :: [Coord]
            , redPieces :: [Coord]
            , blackKings :: [Coord]
            , redKings :: [Coord]
            , status :: Status
            , message :: String 
            , history :: [Move]}
              deriving (Show, Eq)


-- Your job is to write two functions of these types

type CheckersEngine = Move -> GameState -> GameState
type GenMove = GameState -> Move


-- GameConfig is essentially a config file 
data PlayerType = Ai GenMove | Human

-- The initial game state

initialGameState :: GameState
initialGameState =
  GameState { blackPieces = blackInit
            , redPieces = redInit
            , blackKings = []
            , redKings = []
            , status = Turn Red
            , message = ""
            , history = []}

blackInit :: [Coord]
blackInit = [ (1,0), (3,0), (5,0), (7,0)
            , (0,1), (2,1), (4,1), (6,1)
            , (1,2), (3,2), (5,2), (7,2)]

redInit :: [Coord]
redInit = [ (0,7), (2,7), (4,7), (6,7)
          , (1,6), (3,6), (5,6), (7,6)
          , (0,5), (2,5), (4,5), (6,5)]

