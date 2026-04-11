factorial x = if x == 1 then 1 else x * factorial (x - 1)
fibonacci x = if x < 2 then x else fibonacci (x - 1) + fibonacci (x - 2)
durry f x y = f (x, y)
undurry f x = let (x1, x2) = x in f x1 x2
