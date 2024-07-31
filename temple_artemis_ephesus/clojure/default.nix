{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.clojure;
in {
  options.${osConfig.networking.hostName}.home.clojure.enable = lib.mkEnableOption "clojure-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        clojure
        babashka
        leinigen
      ];
    };
  };
}
