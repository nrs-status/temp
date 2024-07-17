#helper file used for initializing the repl. use :a import ./replBase.nix inputs
flakeInputs: rec {
  pkgs = import flakeInputs.nixpkgs {config.allowUnfree = true;};
  lib = pkgs.lib;
  helpers = import ./lighthouse_alexandria {
    inherit pkgs;
    inherit lib;
    nixvim = flakeInputs.nixvim;
    systemType = "x86_64-linux";
  };
  pkgDotNixDerivationsAttrs = helpers.createAttrsFromPkgDotNixFiles ./temple_artemis_ephesus;

  overlay = final: prev: builtins.mapAttrs (name: value: prev.pkgs.callPackage value {}) pkgDotNixDerivationsAttrs;
  pkgs2 = import flakeInputs.nixpkgs {
    overlays = [overlay];
  };
  overlay2 = final: prev: pkgDotNixDerivationsAttrs;
  pkgs3 = import flakeInputs.nixpkgs {
    overlays = [overlay2];
  };
  wanted = pkgs2.nixvim;
}
