{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_harkamalRandhawaCheckers (
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

bindir     = "/media/Storage/Repos/Git/Programing/Haskell/harkamalRandhawaCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/bin"
libdir     = "/media/Storage/Repos/Git/Programing/Haskell/harkamalRandhawaCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/lib/x86_64-linux-ghc-8.10.4/harkamalRandhawaCheckers-0.1.0.0-5Z00ARHVADcAPzoArbsdNo-harkamalCheckers"
dynlibdir  = "/media/Storage/Repos/Git/Programing/Haskell/harkamalRandhawaCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/lib/x86_64-linux-ghc-8.10.4"
datadir    = "/media/Storage/Repos/Git/Programing/Haskell/harkamalRandhawaCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/share/x86_64-linux-ghc-8.10.4/harkamalRandhawaCheckers-0.1.0.0"
libexecdir = "/media/Storage/Repos/Git/Programing/Haskell/harkamalRandhawaCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/libexec/x86_64-linux-ghc-8.10.4/harkamalRandhawaCheckers-0.1.0.0"
sysconfdir = "/media/Storage/Repos/Git/Programing/Haskell/harkamalRandhawaCheckers/.stack-work/install/x86_64-linux-tinfo6/cd5d2756ddb03023e5876ecadf75c3f05d10d70285e8d4e461ebc27af3ecea8f/8.10.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "harkamalRandhawaCheckers_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "harkamalRandhawaCheckers_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "harkamalRandhawaCheckers_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "harkamalRandhawaCheckers_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "harkamalRandhawaCheckers_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "harkamalRandhawaCheckers_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
