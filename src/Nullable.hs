{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE DerivingVia #-}

module Nullable where

import Prelude hiding (null)

class Nullable a where
  isNull :: a -> Bool
  null :: a
  default isNull :: (Eq a) => a -> Bool
  isNull x = x /= x

instance Nullable (Maybe a) where
  isNull Nothing = True
  isNull _ = False
  null = Nothing

instance Nullable [a] where
  isNull [] = True
  isNull _ = False
  null = []

newtype Nullout a = Nullout (Maybe a)

instance Nullable (Nullout a) where
  isNull (Nullout Nothing) = True
  isNull _ = False
  null = (Nullout Nothing)

newtype Nullin a = Nullin (Maybe a)

instance (Nullable a) => Nullable (Nullin a) where
  isNull (Nullin Nothing) = True
  isNull (Nullin (Just x)) = isNull x
  null = (Nullin Nothing)
