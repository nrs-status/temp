{ lib, ... }:
let
  getNixFiles = import ../../resources/nix_functions/getNixFiles.nix { inherit lib; };
in
{
  # @NOTE: Additional modules must be at least staged in git.
  imports = getNixFiles {
    dir = ./.;
    ignore = []; 
  };
}
