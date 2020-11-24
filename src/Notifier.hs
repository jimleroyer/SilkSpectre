{-# LANGUAGE 
    NamedFieldPuns,
    OverloadedStrings
#-}

module Notifier
    (   notify
    ) where

import Config (ConfigInfo(..), readConfig)
import Control.Lens ( (&), (?~), view ) 
import Data.Either () 
import Data.Text ( Text, pack )
import Network.Wreq
    ( basicAuth,
      partText,
      postWith,
      defaults,
      auth,
      responseStatus,
      statusCode )


postSms :: ConfigInfo -> String -> String -> IO Int
postSms ConfigInfo{to, from, sid, user, key} url shopName = 
    view (responseStatus.statusCode) <$> _postSms
        where opts = defaults & auth ?~ basicAuth user key
              _postSms = postWith opts url [partText "To" to, 
                                            partText "From" from,
                                            partText "MessagingServiceSid" sid,
                                            partText "Body" (pack ("PS5 Available at " ++ shopName ++ "! Wake up man!"))]

toEither :: Int -> Either Text Text
toEither status 
    | status >= 200 || status < 300  = Right "Sent notification"
    | otherwise = Left $ pack ("Could not send notification! Status: " ++ show status)

notify :: String -> String -> IO (Either Text Text)
notify url shopName = do
    config <- readConfig "app.config"
    httpStatus <- postSms config url shopName
    return (toEither httpStatus)
