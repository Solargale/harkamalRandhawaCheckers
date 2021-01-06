module Checkers.FrontEnd.Terminal (frontend) where

import Checkers.Types

import Checkers.FrontEnd.Types
import Checkers.FrontEnd.Terminal.Types
import Checkers.FrontEnd.Terminal.Draw
import Checkers.FrontEnd.Terminal.Cursor
import Checkers.FrontEnd.Terminal.Event
-- import System.Directory
-- import Control.Monad.IO.Class
-- import Data.Maybe
import Lens.Micro
import Lens.Micro.Extras
import Brick.Main
import Brick.Types

tuiApp :: App TuiState e ResourceName
tuiApp =
    App
        { appDraw = drawTui
        , appChooseCursor = showFirstCursor
        , appHandleEvent = handleTuiEvent
        , appStartEvent = pure
        , appAttrMap = const theAttributes}


frontend :: FrontEnd
frontend state = do
    let initialState = TuiState {board=initialBoard, move=[], king = False, config = state} 
    endState <- defaultMain tuiApp initialState
    print (endState^.configL.stateL)