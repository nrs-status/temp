{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.ai;
in {
  options.${osConfig.networking.hostName}.home.ai.enable = lib.mkEnableOption "ai-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ollama
      ];
    };
  };
}
