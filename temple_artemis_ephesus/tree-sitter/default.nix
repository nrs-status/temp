{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.tree-sitter;
in {
  options.${osConfig.networking.hostName}.home.tree-sitter.enable = lib.mkEnableOption "tree-sitter packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        tree-sitter
      ];
    };
  };
}
