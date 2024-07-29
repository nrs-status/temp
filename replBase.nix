#helper file used for initializing the repl. use :a import ./replBase.nix inputs
flakeInputs: rec {
  pkgs = import flakeInputs.nixpkgs {config.allowUnfree = true;};
  lib = pkgs.lib;
  helpers = import ./lighthouse_alexandria {
    inherit pkgs;
    inherit lib;
    nixvim = flakeInputs.nixvim;
    system = "x86_64-linux";
  };
  pkgDotNixDerivationsAttrs = helpers.createAttrsFromCustomPackagingFiles ./temple_artemis_ephesus;
}
