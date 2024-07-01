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
        cabal-install #package management
      ];
    };
  };
}
