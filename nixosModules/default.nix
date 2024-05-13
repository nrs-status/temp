{ lib, ... }@inputs:
let
  utils = import ../utils inputs;
  allNixFilesExceptFirstDefault = utils.recursivelyListNixFilesExceptThoseInIgnoreList {
    dir = ./.;
    ignore = [ ./default.nix ];
  };
  onlyKeepMainDefaultFileInEachSubdir = lib.filter (x: lib.hasSuffix "default.nix" x) allNixFilesExceptFirstDefault; 
in
# @NOTE: Additional modules must be at least staged in git
{
  imports = onlyKeepMainDefaultFileInEachSubdir;
}

