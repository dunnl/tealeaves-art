{
  description = "A flake for building Tealeaves art";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in  {
      packages.x86_64-linux = rec
        { default = tealeaves-art-gen;
          tealeaves-art-gen =
            pkgs.haskellPackages.callPackage (import ./tealeaves-art-gen.nix) {};
          tealeaves-art =
            pkgs.stdenv.mkDerivation rec {
              name = "tealeaves-art";
              src = ./.;
              phases = "buildPhase installPhase";
              version = "0.1";
              buildInputs = [ pkgs.ruby
                              pkgs.which
                              tealeaves-art-gen
                            ];
              tealeaves-art = tealeaves-art-gen;
              buildPhase = ''
                  ruby $src/make.rb
                  '';
              installPhase = ''
                  mkdir -p $out
                  cp -r _out/* $out
                  '';
              meta = {
                description = "Art for Tealeaves";
                longDescription = ''
                  This package contains logos and brandings
                  for Tealeaves, generated with Haskell's diagram package.
                  '';
                homepage = "http://tealeaves.science";
                license = pkgs.lib.licenses.mit;
              };
          };
      };
    };
}
