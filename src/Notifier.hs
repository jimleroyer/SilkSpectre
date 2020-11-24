{-# LANGUAGE 
    NamedFieldPuns,
    OverloadedStrings
#-}

module Notifier
    (   notify
    ) where

import Config (ConfigInfo(..), readConfig)
import Control.Lens ( (&), (?~), view ) 
import Data.ByteString.UTF8 as BSU ( toString )
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


postSms :: ConfigInfo -> String -> IO Int
postSms ConfigInfo{to, from, sid, user, key} shopName = 
    view (responseStatus.statusCode) <$> _postSms
        where opts = defaults & auth ?~ basicAuth user key
              url = twilioEndpoint (BSU.toString user)
              _postSms = postWith opts url [partText "To" to, 
                                            partText "From" from,
                                            partText "MessagingServiceSid" sid,
                                            partText "Body" (pack ("PS5 Available at " ++ shopName ++ "! Wake up man!"))]

toEither :: Int -> Either Text Text
toEither status 
    | status >= 200 || status < 300  = Right "Sent notification"
    | otherwise = Left $ pack ("Could not send notification! Status: " ++ show status)

notify :: String -> IO (Either Text Text)
notify shopName = do
    config <- readConfig "app.config"
    httpStatus <- postSms config shopName
    return (toEither httpStatus)

twilioEndpoint :: String -> String
twilioEndpoint userId = "https://api.twilio.com/2010-04-01/Accounts/" ++ 
                            userId ++ 
                            "/Messages.json"
