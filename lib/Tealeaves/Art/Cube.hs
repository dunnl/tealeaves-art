module Tealeaves.Art.Cube where

import Diagrams.Prelude
import Diagrams.Backend.SVG
import Data.Colour
import Data.Typeable (Typeable (..))
import Data.Maybe (fromMaybe)
import qualified Diagrams.TwoD.Path.Boolean as B

import Tealeaves.Art.Common

jr = Just tl_red
jg = Just tl_green
jb = Just tl_blue
n = Nothing

circleFromColors :: (Maybe (Colour Double), Maybe (Colour Double), Maybe (Colour Double)) -> Diagram B
circleFromColors (ml, mc, mr) =
    mconcat [leftPart, rightPart, centerPart, outline]
  where
    leftPart   = cr ml # clipBy (square 2 # translateX (-1.4))
    rightPart  = cr mr # clipBy (square 2 # translateX 1.4)
    centerPart = cr mc # clipBy (B.intersection Winding (sq 0.5) (sq (-0.5)))
    outline    = circle 1 # fc black # lwN 0.01
    cr mcolor  = circle 1 # fc (fromMaybe white mcolor)
    sq off     = square 4 # translate (off ^& 0)

zipApply :: [a -> b] -> [a] -> [b]
zipApply fs xs = (\(f, a) -> f a) <$> zip fs xs

zipHash :: [a] -> [a -> b] -> [b]
zipHash = flip zipApply

allCircles = hcat [circleFromColors (l, c, r) | l <- [n,jr], c <- [n,jb], r <- [n, jg]]

data NodeType = F | D | T | DT
  deriving (Typeable, Eq, Ord, Show)
instance IsName NodeType

data FunType = Fun | Mon
  deriving (Typeable, Eq, Ord, Show)
instance IsName FunType

colorsFromNode :: NodeType -> FunType -> (Maybe (Colour Double), Maybe (Colour Double), Maybe (Colour Double))
colorsFromNode node fun = (left, center, right)
  where
    left   = case node of {D -> Just (tl_red);   DT -> Just (tl_red);   _ -> Nothing}
    right  = case node of {T -> Just (tl_green); DT -> Just (tl_green); _ -> Nothing}
    center = case fun  of {Mon -> Just (tl_blue); Fun -> Nothing }

circleFromNode :: (NodeType, FunType) -> Diagram B
circleFromNode (n, f) = circleFromColors (colorsFromNode n f)

myx = unitX # scaleX 10 # rotateBy (-1/20) :: V2 Double
myy = unit_Y # scaleY 8 # rotateBy (-1/8) :: V2 Double

pts = fromOffsets [myx, myy, -myx, -myy]

bottom = atPoints pts $ (circleFromNode <$> nodes) `zipHash` [(# named F), (# named D), (# named DT), (# named T)]
  where
    nodes = [(F,Fun), (D,Fun), (DT,Fun), (T,Fun)]
top = atPoints (translateY 6 <$> pts) $ (circleFromNode <$> nodes) `zipHash` [(# named F), (# named D), (# named DT), (# named T)]
  where
    nodes = [(F,Mon), (D,Mon), (DT,Mon), (T,Mon)]

connectsOutside :: (TypeableFloat n, Renderable (Path V2 n) b, IsName n1, IsName n2) => [(n1, n2)] -> QDiagram b V2 n Any -> QDiagram b V2 n Any
connectsOutside names = applyAll $ (\(n1,n2) -> (# connectOutside n1 n2)) <$> names

mkArrows = connectsOutside [(F, D), (F, T), (D, DT), (T, DT)]

typeclass_cube :: Diagram B
typeclass_cube =
  ((Mon .>> top # mkArrows) <> (Fun .>> bottom # mkArrows))
  # connectsOutside ((\n -> (Fun .> n, Mon .> n)) <$> [F, D, T, DT])
