{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.gtk;
in {
  options.${osConfig.networking.hostName}.home.gtk.enable = lib.mkEnableOption "gtk";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [ dconf ];
    };

    gtk = {
      enable = true;
  #    font = {
  #      package = pkgs.iosevka;
  #      name = "Iosevka";
  #    };
      theme = {
        package = pkgs.qogir-icon-theme;
        name = "Qogir";
      };
      iconTheme = {
        package = pkgs.qogir-icon-theme;
        name = "Qogir";
      };
    };
  };
}
