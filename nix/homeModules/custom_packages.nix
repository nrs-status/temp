{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.custom_packages;
in {
  options.${osConfig.networking.hostName}.home.custom_packages.enable = lib.mkEnableOption "Custom Packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        (pkgs.callPackage ../../custom_packages/fish.nix {})
      ];
    };
  };
}

