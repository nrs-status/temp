{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.javascript;
in {
  options.${osConfig.networking.hostName}.home.javascript.enable = lib.mkEnableOption "javascript-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nodejs_22
        prettierd #formatter
      ];
    };
  };
}
