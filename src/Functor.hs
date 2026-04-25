module Functor where

newtype Function a b = Function {function :: a -> b}
newtype Method b a = Method {method :: a -> b}

class Bifunctor f where
  bimap :: (a -> c) -> (b -> d) -> f a b -> f c d
  first :: (a -> c) -> f a b -> f c b
  first f = bimap f id
  second :: (b -> d) -> f a b -> f a d
  second f = bimap id f

class Contravariant f where
  contramap :: (b -> a) -> f a -> f b

class Profunctor f where
  dimap :: (c -> a) -> (b -> d) -> f a b -> f c d
  lmap :: (c -> a) -> f a b -> f c b
  lmap f = dimap f id
  rmap :: (b -> d) -> f a b -> f a d
  rmap f = dimap id f

instance Bifunctor Either where
  bimap f _ (Left a) = Left (f a)
  bimap _ g (Right b) = Right (g b)

instance Contravariant (Method r) where
  contramap f (Method g) = Method (g . f)

instance Profunctor Function where
  dimap f g (Function h) = Function (g . h . f)
