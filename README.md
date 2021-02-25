# CPSC 449 Checkers package

A library for making a checkers game for the University of Calgary's Programming Paradigms class.
This should serve as a gentle introduction to software development in Haskell.
You *will* need to use cabal to build this project.

## Getting set up (Unix & WSL2)

Create a directory named yourNameCheckers, and put the following files under it, replacing any instance of yourName with your name.
Then create the following files in the directory you just created.

cabal.project
``` yaml
packages: .

source-repository-package
    type: git
    location: https://github.com/SgtWiggles/CheckersRedux.git

source-repository-package
    type: git
    location: https://github.com/SgtWiggles/checkers-brick.git
```

DIR-NAME.cabal
``` yaml
cabal-version:       >=1.10
-- Initial package description 'DIR-NAME.cabal' generated by 'cabal
-- init'.  For further documentation, see
-- http://haskell.org/cabal/users-guide/

name:                yourNameCheckers
version:             0.1.0.0
-- synopsis:
-- description:
-- bug-reports:
-- license:
license-file:        LICENSE
author:              Ben MacAdam
maintainer:          benjamin.macadam@ucalgary.ca
-- copyright:
-- category:
build-type:          Simple
extra-source-files:  CHANGELOG.md

executable yourNameCheckers
  ghc-options:  -threaded
  main-is:             Main.hs
  hs-source-dirs: src
  -- other-modules:      YOUR-MODULES
  -- other-extensions:
  build-depends:        base
                      , checkers
                      , checkers-brick
  -- hs-source-dirs:
  default-language:    Haskell2010
```
Once the above is set up, you should be able to use `cabal build` to build your project and `cabal run` to run your project.

## Getting set up (Windows)

As Windows does not have VTE, the brick frontend cannot be used.
Thus, the set up process is slightly different and is as follows.

Create a folder named yourNameCheckers, replacing yourName with your name.
Then create the following files in the directory you just created.

cabal.project
``` yaml
packages: .

source-repository-package
    type: git
    location: https://github.com/SgtWiggles/CheckersRedux.git
```

DIR-NAME.cabal
``` yaml
cabal-version:       >=1.10
-- Initial package description 'DIR-NAME.cabal' generated by 'cabal
-- init'.  For further documentation, see
-- http://haskell.org/cabal/users-guide/

name:                yourNameCheckers
version:             0.1.0.0
-- synopsis:
-- description:
-- bug-reports:
-- license:
license-file:        LICENSE
author:              Ben MacAdam
maintainer:          benjamin.macadam@ucalgary.ca
-- copyright:
-- category:
build-type:          Simple
extra-source-files:  CHANGELOG.md

executable yourNameCheckers
  ghc-options:  -threaded
  main-is:             Main.hs
  hs-source-dirs: src
  -- other-modules:      YOUR-MODULES
  -- other-extensions:
  build-depends:        base
                      , checkers
  -- hs-source-dirs:
  default-language:    Haskell2010
```

If you would like to use checkers-brick on Windows you are going to have to install WSL2, along with GHC and Cabal in that WSL2 instance.
From there, you can follow the Unix and WSL2 setup instructions.
Once the above is set up, you should be able to use `cabal build` to build your project and `cabal run` to run your project.

### A note on sharing your checkers game for the tournament

There will likely be a small tournament to test your AIs, and you will be able to test your AI against Robin's.
To make it easy to compete, I recommend the following layout.

-   Use a source directory, "src". Keep your main function in this module.
-   When submitting, please have modules named Ai.hs and ApplyMove.hs, as we will use these in testing scripts.
-   For the tournament, please add another folder called  "YourName" (so in my case "BenMacadam") to src, and move your files here. All of your modules should have the prefix YourName.ModuleName (so, for example, the module "src/BenMacAdam/AiPlayers.hs" would be called "BenMacAdam.AiPlayers"). This will make the tournament run smoothly!

This will make it *very* easy to both test your code and to run the checkers tournament, but is not necessary!

## How to use this library

### The basic layout

The library is split up into different modules.

-   The top-level is Checkers, which gives the basic types and some print functionality.
    -   Checkers.Types has the basic types for the checkers board (more on this later)
    -   Checkers.BasicPrint has printing functionality, so you can see what the board looks like from the terminal without booting up a game.
-   The second level is Checkers.FrontEnd, which starts giving the tools for a "frontend" to run your checkers game as a program.
    -   Checkers.FrontEnd.Types has the GameConfig and FrontEnd datatypes, which are necessary for running the game.
    -   Checkers.FrontEnd.Basic is a simple frontend, so you can test a specific move without booting up the game. This is exported as a function "basic".
-   Currently, there is only one non-basic frontend, which is the terminal frontend. A GTK frontend may be implemented in the coming weeks, but this is just to give an ergonomic setting to play against your AIs.

### Checkers

The module Checkers.Types is necessary for basic functionality, Checkers.BasicPrint gives some printing functionality that should help with debugging.

#### Checkers.Types
The basic types used in this checkers game are as follows:

```haskell
    {-
        A coordinate represents a square on the board, it is a pair of integers (x,y).
        The board is 0-indexed, where (_,0) is the top row of the board, and (0,_) is the left-most column.
        The state of the board is given as a list of coordinates.
    -}
    type Coord = (Int, Int)
    type PieceState = [Coord]
    {-
        A move is essentially a list of coordinates, tracing out the path travelled by a piece, 
        where you keep track of whether or not the piece is a Pawn or King using the PorK datatype.
        The list goes "in the right order", e.g. [firstSquare, secondSquare, ...]
    -}
    data PorK a = P a | K a  
        deriving (Show,Eq, Read)

    type Move = [PorK Coord]
    {-
        Some examples
    -}
    -- a single move forwards
    simpleMoveExample :: Move
    simpleMoveExample = [P (0,1), P (1,2)] 
    -- a pawn jumps a piece, becomes a king, then moves backwards to jump another piece
    jumpMoveExample :: Move
    jumpMoveExample = [P (4,2), K(2,0), K (0,2)] 
```

The other main pieces of state are given by the status:

``` haskell
    {-
        The player datatype is the red/black colour.
    -}
    data Player = Red | Black -- 2 players, red and black
        deriving (Eq, Show)
    {-
        It is either red/black's turn, or the game has finished.
    -}
    data Status = Turn Player | GameOver
        deriving (Eq,Show)
```

These are all wrapped together as the "GameState" datatype.

``` haskell
    data GameState =
        GameState { blackPieces :: PieceState
                  , redPieces :: PieceState
                  , blackKings :: PieceState
                  , redKings :: PieceState
                  , status :: Status
                  , message :: String 
                  , history :: [Move]}
                    deriving (Show, Eq)
```

Going over each field:

-   (black/red)Pieces is the list of pawns, and (black/red)Kings is the list of kings. 
-   The status tells you whose turn it is, or if the game has finished.
-   The message lets a human player know what's happened
    -   Whose turn is it?
    -   If a player attempts an illegal move, you should tell them why it was illegal (explained in Robin's notes).
    -   If the game is over, let the player know who won.
-   The history (should) have the history of all moves that have been made. This is useful for your AI, and when determining if a move is legal (you cannot repeat states).

Your job in this assignment is two write two programs - a game engine for checkers and an AI for checkers.
These programs have the following types.

``` haskell
type CheckersEngine = Move -> GameState -> GameState
type GenMove = GameState -> Move
```

The game engine is "CheckersEngine", so it will take a proposed move, a gamestate, and 

-   *if the move is valid*, apply that move and update the gamestate,
-   otherwise, it will tell the player they proposed an illegal move by updating the message field, and let them try again.

The GenMove function will take in a gamestate and propose a move. 
See Robin's notes on how to implement an AI using Alpha-Beta pruning.

Finally, we have some convenience types with the initial status of the board.
If you want to test different gamestates, you can just instantiate a new gamestate with different values.

``` haskell
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
```

#### Checkers.BasicPrint

In Checkers.BasicPrint, you can find a pair of printing functions:

``` haskell
printState :: GameState -> [String] 
printBoard :: GameState -> [String]
```

The function printBoard will just print out the board (each String is a line of the board), whereas printState will print out the entire gamestate (so it includes the message, etc).
This will hopefully be useful when debugging.

### Checkers.FrontEnd

The Checkers.FrontEnd level has three basic modules: Checkers.FrontEnd.Types (the types used in making a frontend), Checkers.FrontEnd.Basic (a simple frontend built using Checkers.BasicPrint that should be useful for debugging), and Checkers.FrontEnd.Terminal (a terminal user interface, a TUI, that is a full-fledged checkers game).

**Note** The frontend modules both export a function called "frontend" - if you are importing both you may wish to import qualified to avoid any conflicts!

#### Checkers.FrontEnd.Types

There are three main types for the checkers frontend.
The main building blocks:

``` haskell
{-
  A player is either an AI or a human, where an AI has its move generated by a GenMove,
  whereas the frontend must get information from the user for a human move.
-}
data PlayerType = Ai GenMove | Human

{-
  The GameConfig type is the configuration for a checkers game.
  This includes the engine, the two players, and the state of the game.
-}
data GameConfig = 
  GameConfig { engine :: CheckersEngine
             , blackMove :: PlayerType
             , redMove :: PlayerType
             , state :: GameState}

{-
  A frontend takes in a game configuration and returns an IO (), 
  which is the game loop.
-}
type FrontEnd = GameConfig -> IO ()
```

#### Checkers.FrontEnd.Basic

The basic frontend prints out the game state using Checkers.BasicPrint:

``` console
"Turn Red"
" b b b b "
"b b b b  "
" b b b b "
"         "
"         "
"r r r r  "
" r r r r "
"r r r r  "
"Enter move as a list of coordinates."

```
Moves are entered as strings:
``` haskell
    [P (0,1), P (1,2)] 
```

#### Checkers.FrontEnd.Terminal

The TUI interface for checkers. It exports a function

``` haskell
    frontend :: FrontEnd
```

To interact with the program:

-   Move the cursor using the arrow keys. The cursor is pointing at the square that is lit up.
-   To make a move, press space and that coordinate will be added to the move. The UI will do its best to infer PorK for the coordinate. It should add a king if 
    -   Your first selected square contained a king.
    -   Your previous move had added a king.
    -   You selected a square in the final row (for your perspective) turning a pawn into a king.
    -   Otherwise, it will add a pawn.
    Is is still up to your checkers engine to determine if the move was legal.
-   To propose a move to the game, press enter.
-   To quit, press q.

This part of the program uses concepts that are not covered in the class (or particularly useful for doing the assignment), so looking at the code for this module may be a bit confusing!

## Installation and set-up: Checkers

You should start by making a directory and including the following files:

``` bash
mkdir YOUR-PROJECT-DIR
cd YOUR-PROJECT-DIR
cabal init 
```

This will initialize a cabal project in your directory.

``` console 
~/D/G/YOUR-PROJECT-DIR> ls
CHANGELOG.md            Main.hs                 Setup.hs                YOUR-PROJECT-DIR.cabal
```

If you look inside the .cabal file, you will see the information used by cabal to compile your file:

``` yaml
    cabal-version:       >=1.10
    -- Initial package description 'YOUR-PROJECT-DIR.cabal' generated by 'cabal
    --  init'.  For further documentation, see
    -- http://haskell.org/cabal/users-guide/

    name:                YOUR-PROJECT-DIR
    version:             0.1.0.0
    -- synopsis:
    -- description:
    -- bug-reports:
    -- license:
    license-file:        LICENSE
    author:              Ben MacAdam
    maintainer:          benjamin.macadam@ucalgary.ca
    -- copyright:
    -- category:
    build-type:          Simple
    extra-source-files:  CHANGELOG.md

    executable YOUR-PROJECT-DIR
    main-is:             Main.hs
    -- other-modules:
    -- other-extensions:
    build-depends:       base
    -- hs-source-dirs:
    default-language:    Haskell2010
```
Everything that matters for this assignment is included underneath "executable YOUR-PROJECT-DIR". 

-   "main-is" denotes the main file for your project (where there is a function).
-   "hs-source-dirs" is the directory where the source files for your project can be found. By default, this will simply be the folder YOUR-SOURCE-DIR, but if you uncomment this line you can put your files into a subdirectory.
-   "other-modules" is the list of modules that your main file depends on, you will need to uncomment this line and add all of the modules that you use in your project.
-   "build-depends" is the list of libraries that you are using in your project, when you run "cabal build" this will automatically download and install the necessary packages from Hackage (the package repo for Haskell). This is where you will import "checkers" - however, this package is *not* on Hackage, so you will need to add a cabal.project file.
-   "ghc-options" is *not* listed, but you will need to add it to your cabal file to compile your project (due to the dependency on Brick).

As mentioned earlier, this checkers library is not on hackage, so you will need to import it from github directly. 
Cabal lets you import packages from github repositories, but you must include a cabal project file to add the github repo as a depency to your project.
Make a file named cabal.project in YOUR-PROJECT-DIR containing the following:
``` yaml
    packages: .

    source-repository-package
        type: git
        location: https://github.com/SgtWiggles/CheckersRedux.git
```
The first line ensures that the normal package setup still works, and then adding "source-repository-package" adds this github page as a valid source repository that cabal can install packages from.

Now you should change the executable portion of your cabal file to:
``` yaml
    executable YOUR-PROJECT-DIR
    ghc-options:  -threaded
    main-is:             Main.hs
    hs-source-dirs: src -- if you want to use a source directory, otherwise comment this out
    other-modules:  MODULE -- Use modules to organize your code, rather than writing everything in Main.
    -- other-extensions:
    build-depends:        base
                        , checkers
    -- hs-source-dirs:
    default-language:    Haskell2010
```
To compile your project, use the command:
``` console
cabal build
```
*This will take some time the first time you try to build the program*. This is because it is downloading and building all of the libraries used in this checkers library.

To open GHCI with all of your module interpreted and ready to use, run:
``` console
cabal new-repl
```
To build your project and run it, use the command:
``` console
cabal run
```
If you are getting the error code:
``` console
YOUR-PROJECT-DIR user error (RTS doesn't support multiple OS threads (use ghc -threaded when linking))
```
Then run "cabal clean", make sure you have the "ghc-options:  -threaded" in your cabal file, and try again.
If it's still an issue talk to your TA!


## Installation and Set-up: checkers-brick
This section will assume you have set up CheckersRedux from the above section.

checkers-brick is a terminal frontend for CheckersRedux which is completely optional.
Unlike the basic frontend, it allows you to make moves through selecting pieces with your arrow keys, instead of having to put in coordinates.
For more information on checkers-brick, please refer to the section Checkers.FrontEnd.Terminal.
checkers-brick has a dependency on VTE, thus is available for any Unix-based system (Linux, Mac and WSL2).

To set up this section go back to your .cabal file and add `checkers-brick` to your build depends.
The executable section should look something similar to the following.
```yaml
    executable YOUR-PROJECT-DIR
    ghc-options:  -threaded
    main-is:             Main.hs
    hs-source-dirs: src -- if you want to use a source directory, otherwise comment this out
    other-modules:  MODULE -- Use modules to organize your code, rather than writing everything in Main.
    -- other-extensions:
    build-depends:        base
                        , checkers
                        , checkers-brick
    -- hs-source-dirs:
    default-language:    Haskell2010
```

After you have set checkers-brick in your `build-depends`, you need to tell cabal where to find checkers-brick.
This can be done by adding the following to the bottom of your cabal.project file.
``` yaml
source-repository-package
    type: git
    location: https://github.com/SgtWiggles/checkers-brick.git
```

After this, set up should be complete. The project can then be built and run identically to above.
If you are having troubles setting this up please contact your TA.
