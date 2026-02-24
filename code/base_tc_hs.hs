integerEq :: Integer -> Integer -> Bool
integerEq x y = x == y

-- START
class Eqb a where eqb :: a -> a -> Bool

instance Eqb Integer where eqb = integerEq
instance (Eqb a, Eqb b) => Eqb (a, b) where
  eqb (x1, y1) (x2, y2) = eqb x1 x2 && eqb y1 y2