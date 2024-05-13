{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.etc;
in 
  {
  options.${osConfig.networking.hostName}.home.etc.enable = lib.mkEnableOption "packages that don't fit elsewhere";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        transmission-gtk
        distrobox
      ];
    };

 };
}
