module Tealeaves.Art.Tree where

import Diagrams.Prelude
import Diagrams.Backend.SVG
import Tealeaves.Art.Common

data STLC a =
    Var a
  | App String (STLC a) (STLC a)
  | Lam a (STLC a)

mkNode :: (Color c) => c -> String -> Diagram B -> Diagram B
mkNode c label shape =
  text ""    # fc black # font "freeserif" # fontSize (local 1.8) <>
  shape      # lw 2
             # fcA (toAlphaColour c)
             # pad 2

varNode :: String -> Diagram B
varNode label = mkNode tl_green label
  (triangle 3 # scaleY (-1) # lw 1 # lc tl_green)

appNode :: Diagram B
appNode = mkNode tl_blue ""
  (roundedRect 3 3 0.4) # lc tl_blue

lamNode :: String -> Diagram B
lamNode label = mkNode tl_red label
  (circle 1.5  # lw 1 # lc tl_red)

blueLine = with & headLength .~ local 1
            & arrowHead  .~ noHead
            & shaftStyle %~ lw veryThick . lc tl_blue
            & headStyle %~ fc tl_blue
            & tailStyle %~ fc tl_blue

connect_under' :: (TypeableFloat n, Renderable (Path V2 n) b, IsName n1, IsName n2)
               => ArrowOpts n
               -> n1
               -> n2
               -> QDiagram b V2 n Any
               -> QDiagram b V2 n Any
connect_under' opts n1 n2 =
  withName n1 $ \sub1 ->
  withName n2 $ \sub2 ->
    let [s,e] = map location [sub1, sub2]
    in  flip atop (arrowBetween' opts s e)

connecting :: (TypeableFloat n, Renderable (Path V2 n) b, IsName n1, IsName n2)
                 => [(n1, n2)]
                 -> QDiagram b V2 n Any
                 -> QDiagram b V2 n Any
connecting names = applyAll $ (\(n1, n2) -> (# connect_under' blueLine n1 n2)) <$> names

renderSTLC :: STLC String -> Diagram B
renderSTLC = go [] where
  go nm (Var a)     =
    varNode a # named nm
  go nm (App c l r) =
    (app === (nl ||| nr) # centerX) # connecting [(nm, nmL),(nm, nmR)]
    where
      (nmL, nmR) = ('L':nm, 'R':nm)
      app = appNode # named nm
      nl = go nmL l # named nmL
      nr = go nmR r # named nmR
  go nm (Lam x body) =
    (bindingNode === bodyNode) # connecting [(nm, nmB)]
    where
      nmB = 'B':nm
      bindingNode = lamNode ("λ " ++ x) # named nm
      bodyNode = go nmB body # named nmB

t1 = App "D" (Lam "x" (App "C" (Var "x") (Var "y"))) (App "D" (Lam "x" (Var "z")) (Var "y"))
t2 = Lam "y" (App "" (App "X" (Var "z") (Var "x")) (Lam "x" (Lam "y" (App "" (App "" (Var "y") (Var "z")) (Var "x")))))

