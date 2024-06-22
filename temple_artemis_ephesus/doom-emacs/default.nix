{ config, lib, pkgs, osConfig, nixosVars, ... }:

let cfg = config.${osConfig.networking.hostName}.home.doom-emacs;
in 
  {
  options.${osConfig.networking.hostName}.home.doom-emacs.enable = lib.mkEnableOption "doom emacs";
  config = lib.mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomDir = /etc/nixos/temple_artemis_ephesus/doom-emacs/doom_config;
      doomLocalDir = "${nixosVars.mainUserHomeDir}/.doom"; 
    };

    services.emacs.enable = true;

  };

}
