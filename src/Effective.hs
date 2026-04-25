module Effective where

factorial :: (Num a, Eq a) => a -> a
factorial x = if x == 1 then 1 else x * factorial (x - 1)

fibonacci :: (Num a, Ord a) => a -> a
fibonacci x = if x < 2 then x else fibonacci (x - 1) + fibonacci (x - 2)

durry :: ((a, b) -> c) -> a -> b -> c
durry f x y = f (x, y)

undurry :: (a -> b -> c) -> (a, b) -> c
undurry f x = let (x1, x2) = x in f x1 x2

reversel :: [a] -> [a]
reversel xs = foldl (\xs x -> x : xs) [] xs

reverser :: [a] -> [a]
reverser xs = foldr (\x xs -> xs ++ [x]) [] xs

zipw :: (a -> b -> c) -> [a] -> [b] -> [c]
zipw f xs ys = [f x y | (x, y) <- zip xs ys]

zipf :: (a -> b -> c) -> [a] -> [b] -> [c]
zipf f xs ys = snd $ foldl (\(y : ys, zs) x -> (ys, zs ++ [f x y])) (ys, []) xs

concatMapl :: (a -> [b]) -> [a] -> [b]
concatMapl f xxs = foldl (\y x -> (foldl (\xs x -> xs ++ [x]) y (f x))) [] xxs

concatMapr :: (a -> [b]) -> [a] -> [b]
concatMapr f xxs = foldr (\x y -> (foldr (\x xs -> x : xs) y (f x))) [] xxs

mapApply :: [a -> b] -> [a] -> [b]
mapApply toApply = concatMap (\input -> map ($ input) toApply)

example :: [Int] -> String
example = \xs -> map lookupLetter (mapApply offsets xs)
  where
    letters :: [Char]
    letters = ['a' .. 'z']
    lookupLetter :: Int -> Char
    lookupLetter n = letters !! n
    offsets :: [Int -> Int]
    offsets = [rot13, swap10, mixupVowels]
    rot13 :: Int -> Int
    rot13 n = (n + 13) `rem` 26
    swap10 :: Int -> Int
    swap10 n
      | n <= 10 = n + 10
      | n <= 20 = n - 10
      | otherwise = n
    mixupVowels :: Int -> Int
    mixupVowels n =
      case n of
        0 -> 8
        4 -> 14
        8 -> 20
        14 -> 0
        20 -> 4
        n' -> n'

data BinaryTree a = Leaf | Branch (BinaryTree a) a (BinaryTree a)

showStringTree :: BinaryTree String -> String
showStringTree tree = case tree of
  Leaf -> ""
  Branch left node right -> showStringTree left <> node <> showStringTree right

addElementToIntTree :: BinaryTree Int -> Int -> BinaryTree Int
addElementToIntTree tree value = case tree of
  Leaf -> Branch Leaf value Leaf
  Branch left node right ->
    if value < node
      then
        Branch (addElementToIntTree left value) node right
      else
        Branch left node (addElementToIntTree right value)

doesIntExist :: BinaryTree Int -> Int -> Bool
doesIntExist tree value = case tree of
  Leaf -> False
  Branch left node right ->
    False
      || node == value
      || doesIntExist left value
      || doesIntExist right value

data Expr
  = Lit Int
  | Sub Expr Expr
  | Add Expr Expr
  | Mul Expr Expr
  | Div Expr Expr

safeEval :: Expr -> Either String Int
safeEval expr =
  case expr of
    Lit num -> Right num
    Add arg1 arg2 -> eval' (+) arg1 arg2
    Sub arg1 arg2 -> eval' (-) arg1 arg2
    Mul arg1 arg2 -> eval' (*) arg1 arg2
    Div arg1 arg2 -> eval'' div arg1 arg2
  where
    isInt (Left _) = False
    isInt (Right _) = True
    getInt (Right x) = x
    message = Left "Error: division by zero"

    eval' :: (Int -> Int -> Int) -> Expr -> Expr -> Either String Int
    eval' operator arg1 arg2 =
      let left = safeEval arg1
          right = safeEval arg2
          valid = isInt left && isInt right
          result = Right $ operator (getInt left) (getInt right)
       in if valid then result else message

    eval'' :: (Int -> Int -> Int) -> Expr -> Expr -> Either String Int
    eval'' operator arg1 arg2 =
      let result = eval' operator arg1 arg2
          right = safeEval arg2
          valid = isInt right && (getInt right) /= 0
       in if valid then result else message

prettyPrint :: Expr -> String
prettyPrint expr = (print expr) <> " = " <> result
  where
    result = case (safeEval expr) of
      Left x -> x
      Right x -> show x
    print expr = case expr of
      Lit _ -> parse expr
      Sub left right -> connect left " - " right
      Add left right -> connect left " + " right
      Mul left right -> connect left " × " right
      Div left right -> connect left " ÷ " right
      where
        parse expr = case expr of
          Lit x -> show x
          _ -> "( " <> print expr <> " )"
        connect left op right = (parse left) <> op <> (parse right)
