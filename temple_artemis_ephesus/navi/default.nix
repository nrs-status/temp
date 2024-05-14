{ config, lib, pkgs, osConfig, nixosVars, ... }:

let cfg = config.${osConfig.networking.hostName}.home.navi;
in {
  options.${osConfig.networking.hostName}.home.navi.enable = lib.mkEnableOption "navi with cheatsheets";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        navi
      ];
      file."${nixosVars.mainUserHomeDir}/.local/share/navi/cheats".source = ./cheatsheets; 
    };
  };
}
