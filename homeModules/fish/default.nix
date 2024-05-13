{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.fish;
in {
  options.${osConfig.networking.hostName}.home.fish.enable = lib.mkEnableOption "fish";
  config = lib.mkIf cfg.enable {
    programs.fish = {
      shellAliases =  {
        tree2 = "eza --all --long --tree";
      };
    };
    };
}
