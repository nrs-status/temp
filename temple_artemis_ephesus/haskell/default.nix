{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.haskell;
in {
  options.${osConfig.networking.hostName}.home.haskell.enable = lib.mkEnableOption "haskell-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ghc #compiler
        cabal-install #package manager
        ormolu #formatter, required for conform-nvim
        haskellPackages.hoogle #search function definitions

        haskellPackages.aeson #json library for haskell

        haskellPackages.BNFC #backus naur form converter
        alex #tool for generating lexical analysers in haskell
        happy #parser generator for haskell
      ];
    };
  };
}
