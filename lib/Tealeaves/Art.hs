
module Tealeaves.Art (main) where

import Diagrams.Prelude
import Diagrams.Backend.Rasterific.CmdLine (multiMain)
import Tealeaves.Art.Common
import Tealeaves.Art.Cube
import Tealeaves.Art.Tree

main :: IO ()
main = multiMain $
  [ ("logo", pad 1.1 $ renderSTLC t1)
  , ("tree", pad 1.1 $ renderSTLC (App "" t1 t2))
  , ("cube", pad 1.1 $ typeclass_cube)
  , ("node-f", pad 1.2 $ circleFromNode (F, Fun))
  , ("node-d", pad 1.2 $ circleFromNode (D, Fun))
  , ("node-t", pad 1.2 $ circleFromNode (T, Fun))
  , ("node-dt", pad 1.2 $ circleFromNode (DT, Fun))
  , ("node-m", pad 1.2 $ circleFromNode (F, Mon))
  , ("node-dm", pad 1.2 $ circleFromNode (D, Mon))
  , ("node-tm", pad 1.2 $ circleFromNode (T, Mon))
  , ("node-dtm", pad 1.8 $ circleFromNode (DT, Mon))
  ]







