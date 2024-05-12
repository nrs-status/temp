{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.fonts;
in {
  options.${osConfig.networking.hostName}.home.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      material-design-icons
      iosevka
      font-awesome
      noto-fonts
      noto-fonts-cjk
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];

    fonts.fontconfig.enable = true;
  };
}
