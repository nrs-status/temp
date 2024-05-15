{ config, lib, pkgs, osConfig, nixosVars, ... }:

let cfg = config.${osConfig.networking.hostName}.home.navi;
in {
  options.${osConfig.networking.hostName}.home.navi.enable = lib.mkEnableOption "navi with cheatsheets";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        navi
      ];
      #file.".local/share/navi/cheats".source = ./cheatsheets;
      file.".local/share/navi/cheats".source = pkgs.symlinkJoin {
        name = "navi_cheatsheets_directory";
        paths = let
          fetchedCheatsRepo = builtins.fetchGit {
           url = "https://github.com/denisidoro/cheats";
           rev = "1339965e9615ce00174cc308a41279d9c59aa75f";
         };
        in
        #lib.filesystem.listFilesRecursive ./cheatsheets ++ [ fetchedCheatsRepo.outPath ];
        [ fetchedCheatsRepo.outPath ./cheatsheets ];
      };
      };
    };
}

