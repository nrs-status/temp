{ config, lib, pkgs, osConfig, nixosVars, ... }:

let 
  cfg = config.${osConfig.networking.hostName}.home.doom-emacs;
in 
  {
  options.${osConfig.networking.hostName}.home.doom-emacs.enable = lib.mkEnableOption "doom emacs";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        #required by doom
        findutils
        emacs-all-the-icons-fonts
      ];

      sessionVariables.EMACSDIR = "${nixosVars.mainUserHomeDir}/.config/emacs";
      sessionPath = [
        "${nixosVars.mainUserHomeDir}/.config/emacs/bin"
      ];
 

  };
      programs.emacs = {
        enable = true;
        package = pkgs.emacs-gtk;
      };

    };
}
