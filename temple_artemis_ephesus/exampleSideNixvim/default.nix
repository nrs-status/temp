{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.sideNixvim;
in {
  options.${osConfig.networking.hostName}.home.sideNixvim.enable = lib.mkEnableOption "sideNixvim";
  #tempcomment remove when you see this
  config = lib.mkIf cfg.enable {
    home = { 
      packages = with pkgs; [
        nixvimForAgda
      ];
    };
  };
}
