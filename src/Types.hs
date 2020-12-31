module Types where

import Data.Maybe


type Coord = (Int, Int) -- (x,y), 0-indexed
type Move = [Coord] -- A move is the path determined by your piece.

data Player = Red | Black -- 2 players, red and black
  deriving (Eq, Show)
data Status = Turn Player | Winner (Maybe Player)
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

data GameConfig = 
  GameConfig { engine :: CheckersEngine
             , blackMove :: PlayerType
             , redMove :: PlayerType
             , state :: GameState}

-- There will be multiple frontends to this program; from the AI-programmers viewpoint it doesn't matter.
-- In fact, I'd recommend you avoid looking at their source code, as it uses concepts not covered in class.
-- There is simply a frontend type, and it will be 
type FrontEnd = GameConfig -> IO ()

simpleConfig = GameConfig {
  engine = undefined,
  blackMove = Human,
  redMove = Human,
  state = initialGameState
}

-- Some convenience functions

-- human :: FrontEnd -> ApplyMove -> GameState -> IO ()
-- human fe = fe Human Human

-- redAi :: FrontEnd -> AiMove -> ApplyMove -> GameState -> IO ()
-- redAi fe r = fe (AI r) Human

-- blackAi :: FrontEnd -> AiMove -> ApplyMove -> GameState -> IO ()
-- blackAi fe b = fe Human (AI b)

-- aiTest :: FrontEnd -> AiMove -> AiMove -> ApplyMove -> GameState -> IO ()
-- aiTest fe r b = fe (AI r) (AI b)


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

