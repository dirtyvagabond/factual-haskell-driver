module Main where

import System.Environment (getArgs)
import Network.Factual.API
import Data.Factual.Query.ResolveQuery
import Data.Factual.Response

main :: IO()
main = do
  args <- getArgs
  let oauthKey = head args
  let oauthSecret = last args
  let token = generateToken oauthKey oauthSecret
  let resolveValues = [ ResolveStr "name" "McDonalds"
                      , ResolveStr "address" "10451 Santa Monica Blvd" ]
  let query = ResolveQuery { values = resolveValues
                           , debug  = False }
  result <- executeQuery token query
  putStrLn $ "Status: " ++ status result
  putStrLn $ "Version: " ++ show (version result)
  putStrLn $ "Data: " ++ show (response result)
