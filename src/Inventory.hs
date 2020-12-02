{-# LANGUAGE OverloadedStrings, RecordWildCards #-}

module Inventory
    (   Website(Website),
        WebsiteName(Amazon, BestBuy, EBGames, Walmart),
        websites,
        wName,
        wUrl
     ) where

import Data.Aeson ()
import Data.Decimal ( Decimal )
import Data.Map ()
import Data.Text ( Text )


-- List of supported websites

data Website = Website {
    wName:: WebsiteName,
    wUrl:: String
}

data WebsiteName = Amazon | BestBuy | EBGames | Walmart
    deriving (Eq, Show)

userAgent :: [Char]
userAgent = "Mozilla%2F5.0%20%28X11%3B%20Linux%20x86_64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F44.0.2403.157%20Safari%2F537.36"

amazon2 :: Website
amazon2 = Website {..}
    where
        wName = Amazon
        wUrl = "http://localhost:3000/render?userAgent=Mozilla%2F5.0%20%28Windows%20NT%2010.0%3B%20Win64%3B%20x64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F87.0.4280.60%20Safari%2F537.36&url=https://www.amazon.ca/PlayStation-5-Console/dp/B08GSC5D9G"

bestBuy2 :: Website
bestBuy2 = Website {..}
    where
        wName = BestBuy
        wUrl = "https://www.bestbuy.ca/en-ca/product/playstation-5-console-online-only/14962185"

ebgames2 :: Website
ebgames2 = Website {..}
    where
        wName =EBGames
        wUrl = "http://localhost:3000/render?userAgent=Mozilla%2F5.0%20%28Windows%20NT%2010.0%3B%20Win64%3B%20x64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F87.0.4280.60%20Safari%2F537.36&url=https://www.ebgames.ca/PS5/Games/877522/playstation-5"

walmart2 :: Website
walmart2 = Website {..}
    where
        wName = Walmart
        wUrl = "http://localhost:3000/render?userAgent=Mozilla%2F5.0%20%28Windows%20NT%2010.0%3B%20Win64%3B%20x64%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Chrome%2F87.0.4280.60%20Safari%2F537.36&url=https://www.walmart.ca/en/ip/playstation5-console/6000202198562"

websites :: [Website]
websites = [amazon2, bestBuy2, ebgames2]


-- List of supported products

data Product = Product {
    inventory :: Int,
    sku :: String,
    status:: Text,
    maxPrice:: Decimal,
    inStock:: Bool
}

