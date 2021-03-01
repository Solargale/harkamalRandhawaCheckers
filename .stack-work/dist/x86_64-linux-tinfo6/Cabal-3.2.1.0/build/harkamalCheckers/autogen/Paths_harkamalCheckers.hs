{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_harkamalCheckers (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/media/Storage/Repos/Git/Programing/Haskell/harkamalCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/bin"
libdir     = "/media/Storage/Repos/Git/Programing/Haskell/harkamalCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/lib/x86_64-linux-ghc-8.10.4/harkamalCheckers-0.1.0.0-DoEmdo8dlSyDY5M28bIceB-harkamalCheckers"
dynlibdir  = "/media/Storage/Repos/Git/Programing/Haskell/harkamalCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/lib/x86_64-linux-ghc-8.10.4"
datadir    = "/media/Storage/Repos/Git/Programing/Haskell/harkamalCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/share/x86_64-linux-ghc-8.10.4/harkamalCheckers-0.1.0.0"
libexecdir = "/media/Storage/Repos/Git/Programing/Haskell/harkamalCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/libexec/x86_64-linux-ghc-8.10.4/harkamalCheckers-0.1.0.0"
sysconfdir = "/media/Storage/Repos/Git/Programing/Haskell/harkamalCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "harkamalCheckers_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "harkamalCheckers_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "harkamalCheckers_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "harkamalCheckers_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "harkamalCheckers_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "harkamalCheckers_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
