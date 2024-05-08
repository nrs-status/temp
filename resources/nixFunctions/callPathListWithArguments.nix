#callPackagesFromListOfPathsAndAttrSetOfArguments.nix
#WARNING: has not been tested yet
{ pkgs, listOfFilePaths, attrSetOfArguments }:
let
  getSuffixlessBasename = filePath: pkgs.lib.strings.removeSuffix ".nix" baseNameOf filePath;
  keysOfAttrSetOfArguments = builtins.attrNames attrSetOfArguments;
  makePairOfSuffixlessBasenameNImportedPackage = filePath: let 
    suffixlessBasename = getSuffixlessBasename filePath;
  in
  if (pkgs.lib.elem suffixlessBasename keysOfAttrSetOfArguments) then { suffixlessBasename = pkgs.callPackage filePath attrSetOfArguments.suffixlessBasename; } else { suffixlessBasename = pkgs.callPackages filePath {}; };
  listOfPairsFromSuffixlessBasenamesNImportedPackage = map makePairOfSuffixlessBasenameNImportedPackage listOfFilePaths;
in
builtins.listToAttrs listOfPairsFromSuffixlessBasenamesNImportedPackages
