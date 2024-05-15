{ config, lib, pkgs, osConfig, nixosVars, ... }:

let cfg = config.${osConfig.networking.hostName}.home.navi;
in {
  options.${osConfig.networking.hostName}.home.navi.enable = lib.mkEnableOption "navi with cheatsheets";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        navi
      ];
      file = let
        homeDir = nixosVars.mainUserHomeDir;
      in 
      { 
        ".local/share/navi/cheats".source = ./cheatsheets; 
       ".local/share/navi" = { 
         source = ./empty_dir_holder/test;
         target = ".local/share/navi/testingfold/test";
       };

      };
    };
  };
}
