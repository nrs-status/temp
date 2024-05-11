{ lib, ... }:
let 
  utils = ../../utils { inherit lib; }; 
in
{
  # Import all your configuration modules here
  imports = utils.recusrivelyListNixFilesExceptThoseInIgnoreList {
    dir = ./.;
    ignore = [ ./default.nix ]
  };
}
