#will create an attribute set from the nix files in the current directory; the key is the suffixless filename, the value is callPackage $FILENAME {}
{ pkgs, ... }:
pkgs.lib.filesystem.packagesFromDirectoryRecursive {
  callPackage = pkgs.callPackage;
  directory = ./.;
}
