{-# LANGUAGE LambdaCase #-}

module DConf2Nix where

import qualified Data.Text.IO                  as T
import           DConf.Data
import           DConf                          ( dconfParser )
import qualified Nix
import           Text.Parsec.Text               ( parseFromFile )

dconf2nix :: InputFilePath -> OutputFilePath -> IO ()
dconf2nix (InputFilePath input) (OutputFilePath output) = do
  parseFromFile dconfParser input >>= \case
    Left  err -> error (show err)
    Right xs  -> do
      T.writeFile output Nix.renderHeader
      traverse (\e -> T.appendFile output (unNix $ Nix.renderEntry e)) xs
  T.appendFile output Nix.renderFooter
