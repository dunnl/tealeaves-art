# Modified from
# https://www.cs.yale.edu/homes/lucas.paul/posts/2017-04-10-hakyll-on-nix.html
let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  callPackage = pkgs.haskellPackages.callPackage;
in
rec {
  tealeaves-art-gen-raw = callPackage (import ./tealeaves-art.nix) {};
  tealeaves-art-gen = tealeaves-art-gen-raw.overrideAttrs (final: prev: {
    src = pkgs.nix-gitignore.gitignoreSourcePure ./.gitignore_nix ./.;
  });
  tealeaves-art = stdenv.mkDerivation rec {
    name = "tealeaves-art";
    src = ./.;
    phases = "unpackPhase buildPhase";
    version = "0.1";
    buildInputs = [ tealeaves-art-gen ];
    buildPhase = ''
      export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
      export LANG=en_US.UTF-8
      tealeaves-art-gen build
      mkdir $out
      cp -r out/* $out
    '';
    meta = {
      description = "SVG art for Tealeaves";
      longDescription = ''
          This package contains the entire set of
          .svg files used for Tealeaves, which are generated
          with Haskell's diagram package.
        '';
      homepage = "http://tealeaves.science";
      license = pkgs.lib.licenses.mit;
    };
  };
}
