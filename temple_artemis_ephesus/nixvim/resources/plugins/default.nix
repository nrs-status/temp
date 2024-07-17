{lib, ...} @ inputs: let
  helpers = import ../../../../lighthouse_alexandria inputs;
  allNixFilesExceptFirstDefault = helpers.recursivelyListNixFilesExceptThoseInIgnoreList {
    dir = ./.;
    ignore = [./default.nix];
  };
  importAllInList = builtins.map (x: import x) allNixFilesExceptFirstDefault;
in
  lib.attrsets.mergeAttrsList importAllInList
