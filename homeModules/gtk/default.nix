{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.gtk;
in {
  options.${osConfig.networking.hostName}.home.gtk.enable = lib.mkEnableOption "gtk";
  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.qogir-icon-theme;
        name = "Qogir";
      };
    };
  };
}
