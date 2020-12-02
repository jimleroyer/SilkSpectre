{-# LANGUAGE OverloadedStrings, NamedFieldPuns #-}

module Scraper
    ( scrape
    ) where
import Control.Monad ( guard )
import Data.Aeson ()
import Data.Text ( Text, isInfixOf )
import Text.HTML.Scalpel
    ( chroot,
      text,
      texts,
      (@:),
      (@=),
      hasClass,
      anySelector,
      scrapeURL,
      Scraper,
      TagName(AnyTag) )
import Inventory ( Website(..), WebsiteName(..) )


amazonScraper :: Scraper Text [Text]
amazonScraper = chroot ("div" @: ["id" @= "availability"]) $ do
                    contents <- text anySelector
                    guard ("Currently unavailable" `isInfixOf` contents)
                    texts anySelector

bestBuyScraper :: Scraper Text [Text]
bestBuyScraper = chroot ("p" @: [hasClass "messageDetails_238LF"]) $ do
                    contents <- text anySelector
                    guard ("sold out" `isInfixOf` contents)
                    texts anySelector

ebGamesScraper :: Scraper Text [Text]
ebGamesScraper = chroot ("a" @: ["style" @= "display: block;"]) $ do
                    contents <- text anySelector
                    guard ("Out of Stock" `isInfixOf` contents)
                    texts anySelector

walmartScraper :: Scraper Text [Text]
walmartScraper = chroot (AnyTag @: ["data-automation" @= "online-only-label"]) $ do
                    contents <- text anySelector
                    guard ("Out of stock" `isInfixOf` contents)
                    texts anySelector


scrape :: Website -> IO (Maybe [Text])
scrape Website{ wName, wUrl }
    | wName == Amazon  = scrapeURL wUrl amazonScraper
    | wName == BestBuy = scrapeURL wUrl bestBuyScraper
    | wName == EBGames = scrapeURL wUrl ebGamesScraper
    | wName == Walmart = scrapeURL wUrl walmartScraper
