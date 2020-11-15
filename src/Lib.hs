{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( scrap
    ) where

import Text.HTML.Scalpel ( texts, (@:), hasClass, Scraper, scrapeURL )
import Data.Text ( Text )
import Control.Monad ( forM_ )

scrapper :: String -> IO (Maybe [Text])
scrapper url = scrapeURL url section where
    section :: Scraper Text [Text]
    section = texts $ "p" @: [hasClass "messageDetails_238LF"]

printScrapeResults :: Maybe [Text] -> IO ()
printScrapeResults Nothing = putStrLn "Something went wrong!"
printScrapeResults (Just []) = putStrLn "Couldn't scrape anything!"
printScrapeResults (Just results) = forM_ results print

scrap :: String -> IO ()
scrap url = do
    results <- scrapper url
    printScrapeResults results
