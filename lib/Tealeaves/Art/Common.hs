module Tealeaves.Art.Common where

import Data.Colour.Palette.BrewerSet
import Data.Colour.Palette.ColorSet

--colors  = brewerSet Pastel1 9
--colors = brewerSet Set1 9
colors = [d3Colors1 n | n <- [0..9]]

tl_red = colors !! 3
tl_green = colors !! 2
tl_blue = colors !! 0
