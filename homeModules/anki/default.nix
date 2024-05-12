{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.anki;
in {
  options.${osConfig.networking.hostName}.home.anki.enable = lib.mkEnableOption "anki";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        anki-bin
      ];
    };
  };
}
