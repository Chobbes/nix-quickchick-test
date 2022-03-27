{ lib,
  mkCoqDerivation,
  version ? null,
  coq,
  QuickChick,
  # All of these ocaml packages should probably come from the coq
  # version, or there will be disagreements between compiler versions.
  ocaml ? coq.ocaml,
  ocamlbuild ? coq.ocamlPackagse.ocamlbuild,
  findlib ? coq.ocamlPackagse.findlib,
  perl,
  ... }:

{ qctest =
    mkCoqDerivation {
      namePrefix = [ "coq" ];
      pname = "nix-quickchick-test";
      owner = "Chobbes";

      inherit version;

      propagatedBuildInputs =
        [ coq
          perl
        ] ++
        # Coq libraries
        [ QuickChick
        ] ++
        # These ocaml packages have to come from coq.ocamlPackages to
        # avoid disagreements between ocaml compiler versions.
        [ ocaml
          ocamlbuild
          findlib
        ];

      src = ./.;

      buildPhase = ''
  make
  '';

      installPhase = ''
  mkdir -p $out
  install Test.vo $out/Test.vo
  '';

      meta = {
        description = "Vellvm, a formal specification and interpreter for LLVM";
        license = lib.licenses.gpl3Only;
      };
    };
}
