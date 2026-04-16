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
