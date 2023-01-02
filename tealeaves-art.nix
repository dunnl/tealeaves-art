{ mkDerivation, base, colour, diagrams-contrib, diagrams-lib, diagrams-rasterific
, diagrams-svg, lib, palette, SVGFonts
}:
mkDerivation {
  pname = "tealeaves-art";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base colour diagrams-contrib diagrams-lib diagrams-svg palette diagrams-rasterific SVGFonts
  ];
  executableHaskellDepends = [ base ];
  description = "A Haskell package for generating SVG art for Tealeaves";
  license = lib.licenses.mit;
}
