module FrontEnd.Basic (frontend, feGameDump, printState) where
{-
    This module is a simplistic front-end that will run in a terminal.
    If you can't get the Brick or GTK frontend to work, this is fine.
-}
import Types


printState :: GameConfig -> [String] 
printState g = x:xs
    where x = show (status s)
          xs = printBoard s
          s = state g

printBoard :: GameState -> [String]
printBoard b = [printHLine y b | y <- [0..7]]

-- Display board
printHLine :: Int -> GameState -> String 
printHLine y b = [printSquare (x,y) b | x <- [0..8] ]

printSquare :: Coord -> GameState -> Char
printSquare xy b 
    | xy `elem` (redPieces b) = 'r'
    | xy `elem` (redKings b)  = 'R'
    | xy `elem` (blackPieces b) = 'b'
    | xy `elem` (blackKings b) = 'B' 
    | otherwise = ' '

-- findTurn :: GameState -> GameConfig -> PlayerType
-- findTurn gs = case status gs of
--     Turn Red -> red
--     Turn Black -> black
--     _ -> undefined --Make sure this can't be reached using liquid types 

-- Execture a turn
frontend :: GameConfig -> IO ()
frontend g = case (currentMove g) of
    Nothing -> do
        mapM_ print (printState g)
    Just Human -> do
        mapM_ print (printState g)
        print "Enter move as a list of coordinates."
        move <- getLine
        let s' = (engine g) (read move) (state g)
        frontend g{state = s'}
    Just (Ai f) -> do
        mapM_ print (printState g)
        frontend $ g{state = (engine g) (f (state g)) (state g)}

feGameDump :: GameConfig -> IO ()
feGameDump g = case (currentMove g) of
    Nothing -> do
        print $ state g
        mapM_ print (printState g)
    Just Human -> do
        print $ state g
        mapM_ print (printState g)
        print "Enter move as a list of coordinates."
        move <- getLine
        let s' = (engine g) (read move) (state g)
        frontend g{state = s'}
    Just (Ai f) -> do
        print $ state g
        mapM_ print (printState g)
        frontend $ g{state = (engine g) (f (state g)) (state g)}

currentMove :: GameConfig -> Maybe PlayerType
currentMove conf = case status (state conf) of
    Turn Red -> Just (redMove conf)
    Turn Black -> Just (blackMove conf)
    _ -> Nothing





