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
    phases = "buildPhase installPhase";
    version = "0.1";
    buildInputs = [ pkgs.haskellPackages.cabal-install
                    tealeaves-art-gen pkgs.ruby pkgs.which ];
    tealeaves-art = tealeaves-art-gen;
    buildPhase = ''
      ruby $src/make.rb
    '';
    installPhase = ''
      mkdir -p $out
      cp -r _out/* $out
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
