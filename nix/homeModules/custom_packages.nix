{ config, lib, pkgs, osConfig, ... }:

let 
  cfg = config.${osConfig.networking.hostName}.home.custom_packages;
  getNixFiles = import ../../resources/getNixFiles.nix { inherit lib; };
  callableCallPackage = package: pkgs.callPackage package {};
in {
  options.${osConfig.networking.hostName}.home.custom_packages.enable = lib.mkEnableOption "Custom Packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = map callableCallPackage (getNixFiles {
        dir = ../../resources/custom_packages;
        ignore = ["default.nix" "oh-my-fish-plugins.nix" ];
      });
    };
  };
}

