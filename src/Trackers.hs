{-# LANGUAGE OverloadedStrings, RecordWildCards #-}

module Trackers
    (   Target(TSelector, TScraper),
        Tracker,
        tName,
        tUrl,
        tTarget,
        tracked
    ) where

import Control.Monad ( guard )
import Data.Text ( Text, isInfixOf )
import Text.HTML.Scalpel
    ( chroot,
      text,
      texts,
      (@:),
      (@=),
      hasClass,
      anySelector,
      Scraper,
      Selector,
      TagName(AnyTag) )


-- Data types

data Target = TSelector Selector | TScraper (Scraper Text [Text])

data Tracker = Track {
    tName :: String,
    tUrl :: String,
    tTarget :: Target
}


-- Monitored websites

amazon :: Tracker
amazon = Track {..}
    where
        tName = "Amazon"
        tUrl = "http://localhost:3000/render?userAgent=Mozilla%2F5.0%20%28Windows%20NT%2010.0%3B%20Win64%3B%20x64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F87.0.4280.60%20Safari%2F537.36&url=https://www.amazon.ca/PlayStation-5-Console/dp/B08GSC5D9G"
        tTarget = TScraper $ chroot ("div" @: ["id" @= "availability"]) $ do
                    contents <- text anySelector
                    guard ("Currently unavailable" `isInfixOf` contents)
                    texts anySelector

bestBuy :: Tracker
bestBuy = Track {..}
    where
        tName = "Best Buy"
        tUrl = "https://www.bestbuy.ca/en-ca/product/playstation-5-console-online-only/14962185"
        tTarget = TScraper $ chroot ("p" @: [hasClass "messageDetails_238LF"]) $ do
                    contents <- text anySelector
                    guard ("sold outttt" `isInfixOf` contents)
                    texts anySelector

ebgames :: Tracker
ebgames = Track {..}
    where
        tName ="EBGames"
        tUrl = "http://localhost:3000/render?userAgent=Mozilla%2F5.0%20%28Windows%20NT%2010.0%3B%20Win64%3B%20x64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F87.0.4280.60%20Safari%2F537.36&url=https://www.ebgames.ca/PS5/Games/877522/playstation-5"
        tTarget = TScraper $ chroot ("a" @: ["style" @= "display: block;"]) $ do
                    contents <- text anySelector
                    guard ("Out of Stock" `isInfixOf` contents)
                    texts anySelector

walmart :: Tracker
walmart = Track {..}
    where
        tName = "Walmart"
        tUrl = "http://localhost:3000/render?userAgent=Mozilla%2F5.0%20%28Windows%20NT%2010.0%3B%20Win64%3B%20x64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F87.0.4280.60%20Safari%2F537.36&url=https://www.walmart.ca/en/ip/playstation5-console/6000202198562"
        tTarget = TScraper $ chroot (AnyTag @: ["data-automation" @= "online-only-label"]) $ do
                    contents <- text anySelector
                    guard ("Out of stock" `isInfixOf` contents)
                    texts anySelector

tracked :: [Tracker]
tracked = [amazon, bestBuy, ebgames, walmart]
