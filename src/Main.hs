module Main where

import Moves
import Checkers.FrontEnd.Types
import Checkers.Types

one = GameState {blackPieces = [], redPieces = [], blackKings = [(1,0)], redKings = [(0,3),(2,3)], status = Turn Black, message = "", history = [[K (1,2),K (0,3)],[K (0,1),K (1,0)],[K (0,3),K (1,2)]]}
two = GameState {blackPieces = [], redPieces = [], blackKings = [(6,3),(4,3)], redKings = [(0,1)], status = Turn Red, message = "", history = []}
three = GameState {blackPieces = [], redPieces = [(6,5)], blackKings = [(6,3),(4,3)], redKings = [(0,1),(0,5)], status = Turn Red, message = "", history = []}
four = GameState {blackPieces = [(4,1),(2,1)], redPieces = [], blackKings = [], redKings = [(5,0)], status = Turn Red, message = "", history = []}
five = GameState {blackPieces = [(6,1),(4,1),(2,1)], redPieces = [], blackKings = [], redKings = [(7,2)], status = Turn Red, message = "", history = []}
six = GameState {blackPieces = [(6,3),(6,1),(4,1),(2,1)], redPieces = [], blackKings = [], redKings = [(5,4)], status = Turn Red, message = "", history = []}
seven = GameState {blackPieces = [(4,3),(6,3),(6,1),(4,1),(2,1)], redPieces = [], blackKings = [], redKings = [(3,2)], status = Turn Red, message = "", history = []}
eight = GameState {blackPieces = [(7,0)], redPieces = [(4,5),(6,5)], blackKings = [(4,7)], redKings = [(3,0)], status = Turn Black, message = "", history = []}
nine = GameState {blackPieces = [(7,0)], redPieces = [(4,5),(6,5),(4,3),(6,3)], blackKings = [(5,6)], redKings = [(3,0)], status = Turn Red, message = "", history = []}
ten = GameState {blackPieces = [(7,6)], redPieces = [], blackKings = [(0,7)], redKings = [(1,4),(6,7)], status = Turn Red, message = "", history = []}
eleven = GameState {blackPieces = [(3,3),(5,3),(5,5)], redPieces = [(4,4)], blackKings = [], redKings = [], status = Turn Black, message = "", history = []}
twelve = GameState {blackPieces = [(3,3),(5,3),(5,5)], redPieces = [(4,4),(2,6)], blackKings = [], redKings = [], status = Turn Black, message = "", history = []}
thirteen = GameState {blackPieces = [(6,6)], redPieces = [(7,7)], blackKings = [], redKings = [], status = Turn Black, message = "", history = []}
fourteen = GameState {blackPieces = [(3,3),(5,3),(5,5)], redPieces = [(4,4),(2,6),(4,6),(6,6)], blackKings = [], redKings = [], status = Turn Black, message = "", history = []}
fifteen = GameState {blackPieces = [(4,6)], redPieces = [(3,3)], blackKings = [], redKings = [], status = Turn Black, message = "", history = []}
sixteen = GameState {blackPieces = [(3,3),(5,3),(5,5)], redPieces = [(4,4),(2,6),(6,6)], blackKings = [], redKings = [], status = Turn Black, message = "", history = []}
seventeen = GameState {blackPieces = [(1,0),(3,0),(5,0),(7,0),(0,1),(2,1),(4,1),(6,1),(1,2),(3,2),(5,2),(7,2)], redPieces = [(0,7),(2,7),(4,7),(6,7),(1,6),(3,6),(5,6),(7,6),(0,5),(2,5),(4,5),(6,5)], blackKings = [], redKings = [], status = Turn Red, message = "", history = []}
eighteen = GameState {blackPieces = [], redPieces = [(4,5),(6,5),(4,3),(6,3)], blackKings = [(5,6)], redKings = [], status = Turn Black, message = "", history = []}


testMove :: GameState -> GameConfig
testMove a = GameConfig {
    engine = apply_move,
    blackMove = Human,
    redMove = Human,
    state = a
}

initial :: GameConfig
initial = GameConfig{
    engine = apply_move,
    blackMove = Human,
    redMove = Human,
    state = initialGameState
}


main :: IO ()
main = do
  print "1."
  print (moves one)
  print "2."
  print (moves two)
  print "3."
  print (moves three)
  print "4."
  print (moves four)
  print "5."
  print (moves five)
  print "6."
  print (moves six)
  print "7."
  print (moves seven)
  print "8."
  print (moves eight)
  print "9."
  print (moves nine)
  print "10."
  print (moves ten)
  print "11."
  print (moves eleven)
  print "12."
  print (moves twelve)
  print "13."
  print (moves thirteen)
  print "14."
  print (moves fourteen)
  print "15."
  print (moves fifteen)
  print "16."
  print (moves sixteen)
  print "17."
  print (moves seventeen)
  print "18."
  print (moves eighteen)


-- do
--   frontend testOne
