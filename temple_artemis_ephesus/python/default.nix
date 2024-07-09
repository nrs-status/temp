{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.python;
in {
  options.${osConfig.networking.hostName}.home.python.enable = lib.mkEnableOption "python-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        python312
      ];
    };
  };
}
