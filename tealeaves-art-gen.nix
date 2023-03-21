{ mkDerivation, base, colour, diagrams-contrib, diagrams-lib, diagrams-rasterific
, diagrams-svg, lib, palette, SVGFonts, nix-gitignore
}:
mkDerivation {
  pname = "tealeaves-art-gen";
  version = "0.1.0.0";
  src = nix-gitignore.gitignoreSourcePure ./.gitignore_nix ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    colour
    diagrams-contrib
    diagrams-lib
    diagrams-rasterific
    diagrams-svg
    palette
    SVGFonts
  ];
  executableHaskellDepends = [ base ];
  description = "A Haskell package for generating SVG art for Tealeaves";
  license = lib.licenses.mit;
}
