{ pkgs ? import <nixpkgs> {} }:
pkgs.haskellPackages.shellFor {
  packages = ps: [ ];
  buildInputs = [ pkgs.zlib pkgs.haskellPackages.cabal2nix
                  pkgs.haskellPackages.cabal-install ];
}
