{-# LANGUAGE 
    OverloadedStrings
#-}

{-
Strongly inspired by Cogs and Levers:
https://tuttlem.github.io/2013/07/04/configfile-basics-in-haskell.html
-}

module Config (   
    ConfigInfo(..),
    readConfig
) where

import Control.Monad.Error
    ( join, MonadIO(liftIO), ErrorT(runErrorT) )
import Data.ConfigFile ( emptyCP, readfile, Get_C(get) )
import Data.Text as DT ( Text, pack )
import Data.ByteString.UTF8 as BSU ( ByteString, fromString )


-- Data Types

data ConfigInfo = ConfigInfo { 
    to :: Text,
    from :: Text,
    sid :: Text,
    user :: ByteString,
    key :: ByteString
}

readConfig :: String -> IO ConfigInfo
readConfig f = do
    rv <- runErrorT $ do
        -- open the configuration file
        cp <- join $ liftIO $ readfile emptyCP f
        let x = cp

        -- read out the attributes
        vto <- get x "Twilio" "to"
        vfrom <- get x "Twilio" "from"
        vsid <- get x "Twilio" "sid"
        vkey <- get x "Twilio" "key"
        vuser <- get x "Twilio" "user"

        -- build the config value
        return (ConfigInfo { 
                    to = DT.pack vto,
                    from = DT.pack vfrom,
                    sid = DT.pack vsid,
                    user = BSU.fromString vuser,
                    key = BSU.fromString vkey
                })

    -- in the instance that configuration reading failed we'll
    -- fail the application here, otherwise send out the config
    -- value that we've built
    either (error . snd) return rv
