{ lib, ... }:

let
  getNixFiles = import ../getNixFiles.nix { inherit lib; };
in
  {
    result = getNixFiles {
      dir = ./.;
      ignore = [];
    };
  }
