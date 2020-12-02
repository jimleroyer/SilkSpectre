{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (forM_)
import Monitor(monitor)
import Inventory(websites)

main :: IO ()
main = forM_ websites track
    where track w = do
            ss <- monitor w
            forM_ ss putStrLn
