{-# LANGUAGE OverloadedStrings #-}

module Scrapper
    ( scrape
    ) where

import Data.Text ( Text )
import Text.HTML.Scalpel (
    Scraper, scrapeURL, texts )

import Trackers(Target(TScraper, TSelector))


scrape :: String -> Target -> IO (Maybe [Text])

scrape url (TSelector selector) = scrapeURL url scraper where
    scraper :: Scraper Text [Text]
    scraper = texts selector

scrape url (TScraper scraper) = scrapeURL url scraper
