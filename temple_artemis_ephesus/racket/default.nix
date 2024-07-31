{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.racket;
in {
  options.${osConfig.networking.hostName}.home.racket.enable = lib.mkEnableOption "racket-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        racket
      ];
    };
  };
}
