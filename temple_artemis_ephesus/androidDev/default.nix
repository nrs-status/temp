{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.androidDev;
in {
  options.${osConfig.networking.hostName}.home.androidDev.enable = lib.mkEnableOption "androidDev-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        android-tools
        genymotion
      ];
    };
  };
}
