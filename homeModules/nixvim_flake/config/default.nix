{ lib, ... }:
let 
  utils = import ../../../utils { inherit lib; }; 
in
{
  # Import all your configuration modules here
  imports = utils.recursivelyListNixFilesExceptThoseInIgnoreList {
    dir = ./.;
    ignore = [ ./default.nix ];
  };
}
