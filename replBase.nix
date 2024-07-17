#helper file used for initializing the repl. use :a import ./replBase.nix inputs
flakeInputs: rec {
  pkgs = import flakeInputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  lib = pkgs.lib;
  helpers = import ./lighthouse_alexandria {
    inherit pkgs;
    inherit lib;
    nixvim = flakeInputs.nixvim;
    systemType = "x86_64-linux";
  };
  topass = {
    inherit pkgs;
    nixvim = flakeInputs.nixvim;
    systemType = "x86_64-linux";
  };
  r = helpers.recursivelyImportAllFilesNamedPkgDotNix ./temple_artemis_ephesus;
}
