module Main where

import System.Environment (getArgs)
import Network.Factual.API
import Data.Factual.Query.MatchQuery
import Data.Factual.Response

main :: IO()
main = do
  args <- getArgs
  let oauthKey = head args
  let oauthSecret = last args
  let token = generateToken oauthKey oauthSecret
  let query = MatchQuery [ MatchStr "name" "McDonalds"
                         , MatchStr "address" "10451 Santa Monica Blvd" ]
  result <- executeQuery token query
  putStrLn $ "Status: " ++ status result
  putStrLn $ "Version: " ++ show (version result)
  putStrLn $ "Data: " ++ show (response result)
