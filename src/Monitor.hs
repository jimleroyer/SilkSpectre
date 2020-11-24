{-# LANGUAGE OverloadedStrings #-}

{-|
Module      :  Monitor
Description :  Monitor provided websites for updates.
Copyright   :  (c) <Jimmy Royer>
License     :  MIT

Maintainer  :  jimleroyer@gmail.com
Stability   :  unstable
Portability :  portable
-}

module Monitor
    (   monitor
    ) where

import Data.Text ( unpack )
import Notifier (notify)
import Scrapper (scrape)
import Trackers ( Tracker(..) )


-- Monitor logic

monitor :: Tracker -> IO [[Char]]
monitor tracked = do
    scraped <- scrape url target
    case scraped of
        Just _ -> return ["Playstation is still unavailable at " ++ name ++ "... :("]
        Nothing -> do
            notified <- notify name
            case notified of
                Right msg -> return ["Playstation available at " ++ name ++ "! " ++ unpack msg]
                Left msg -> return ["Playstation available at " ++ name ++ "!.. alas.. " ++ unpack msg]
    where name = tName tracked
          url = tUrl tracked
          target = tTarget tracked
