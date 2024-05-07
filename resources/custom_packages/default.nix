{ lib, ... }:

let
  getNixFiles = import ../resources/getNixFiles.nix { inherit lib; };
in
  {
    imports = getNixFiles {
      dir = ./.;
      ignore = [];
    };
  }
