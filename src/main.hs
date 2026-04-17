-- chapter 1

factorial x = if x == 1 then 1 else x * factorial (x - 1)

fibonacci x = if x < 2 then x else fibonacci (x - 1) + fibonacci (x - 2)

durry f x y = f (x, y)

undurry f x = let (x1, x2) = x in f x1 x2

-- chapter 2

reversel xs = foldl (\xs x -> x : xs) [] xs

reverser xs = foldr (\x xs -> xs ++ [x]) [] xs

zipw f xs ys = [f x y | (x, y) <- zip xs ys]

zipf f xs ys = snd $ foldl (\(y : ys, zs) x -> (ys, zs ++ [f x y])) (ys, []) xs

concatMapl f xxs = foldl (\y x -> (foldl (\xs x -> xs ++ [x]) y (f x))) [] xxs

concatMapr f xxs = foldr (\x y -> (foldr (\x xs -> x : xs) y (f x))) [] xxs

-- chapter 3

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
