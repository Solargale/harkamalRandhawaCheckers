module FrontEnd.Terminal (tui) where

import Types

import FrontEnd.Types
import FrontEnd.Terminal.Types
import FrontEnd.Terminal.Draw
import FrontEnd.Terminal.Cursor
import FrontEnd.Terminal.Event
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


tui :: FrontEnd
tui state = do
    let initialState = TuiState {board=initialBoard, move=[], config = state} 
    endState <- defaultMain tuiApp initialState
    print (endState^.configL.stateL)