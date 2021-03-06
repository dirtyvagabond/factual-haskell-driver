module Main where

import System.Environment (getArgs)
import Network.Factual.API
import Data.Factual.Query.FacetsQuery
import Data.Factual.Response

main :: IO()
main = do
  args <- getArgs
  let oauthKey = head args
  let oauthSecret = last args
  let token = generateToken oauthKey oauthSecret
  let query = FacetsQuery { table        = Places
                          , search       = AndSearch ["Starbucks"]
                          , select       = ["country"]
                          , filters      = []
                          , geo          = Nothing
                          , limit        = Nothing
                          , minCount     = Nothing
                          , includeCount = False }
  result <- executeQuery token query
  putStrLn $ "Status: " ++ status result
  putStrLn $ "Version: " ++ show (version result)
  putStrLn $ "Data: " ++ show (response result)
