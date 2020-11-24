{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (forM_)
import Monitor(monitor)
import Trackers(tracked)

main :: IO ()
main = forM_ tracked track
    where track t = do
            ss <- monitor t
            forM_ ss putStrLn
