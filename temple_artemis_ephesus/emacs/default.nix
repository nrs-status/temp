{ config, lib, pkgs, osConfig, self, ... }:

let cfg = config.${osConfig.networking.hostName}.home.emacs;
in {
  options.${osConfig.networking.hostName}.home.emacs.enable = lib.mkEnableOption "emacs";
  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ (import self.inputs.emacs-overlay) ];
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
    };
    services.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
    };

  };
}
