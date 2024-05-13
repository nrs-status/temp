{ lib, ... }@inputs:
let
  lighthouse_alexandria = import ../lighthouse_alexandria inputs;
  allNixFilesExceptFirstDefault = lighthouse_alexandria.recursivelyListNixFilesExceptThoseInIgnoreList {
    dir = ./.;
    ignore = [ ./default.nix ];
  };
  onlyKeepMainDefaultFileInEachSubdir = lib.filter (x: lib.hasSuffix "default.nix" x) allNixFilesExceptFirstDefault; 
in
# @NOTE: Additional modules must be at least staged in git
{
  imports = onlyKeepMainDefaultFileInEachSubdir;
}

