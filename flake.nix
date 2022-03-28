{
  description = "Testing QC in nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
        coq = pkgs.coq;

        coqPkgsFixedQC = pkgs.coqPackages.overrideScope'
          (self: super:
            {
              QuickChick = super.QuickChick.overrideAttrs
                (s : {
                  propagatedBuildInputs = s.propagatedBuildInputs ++ [ coq.ocaml ];
                });
            });

        version = "Chobbes:master";

        brokenQC = (pkgs.callPackage ./release.nix (coq.ocamlPackages // pkgs.coqPackages // { inherit coq version; })).qctest;
        fixedQC = (pkgs.callPackage ./release.nix (coq.ocamlPackages // coqPkgsFixedQC // { inherit coq version; })).qctest;
      in {
        defaultPackage = brokenQC;
        packages.brokenQC = brokenQC;
        packages.fixedQC = fixedQC;
      });
}
