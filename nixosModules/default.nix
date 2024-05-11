{ lib, ... }@inputs:
let
  utils = import ../utils inputs;
in
# @NOTE: Additional modules must be at least staged in git
{
  imports = utils.recursivelyListNixFilesExceptThoseInIgnoreList {
    dir = ./.;
    ignore = [ ./default.nix ];
  };
}

