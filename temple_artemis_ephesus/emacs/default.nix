{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.emacs;
in 
  {
  options.${osConfig.networking.hostName}.home.emacs.enable = lib.mkEnableOption "emacs";
  config = lib.mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomDir = ./doom_config;
      doomLocalDir = /home/${osConfig.networking.hostName}/.doom;
    };

    services.emacs.enable = true;

  };

}
