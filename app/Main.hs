module Main (main) where

import qualified Effective

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  print (Effective.fibonacci 10)
