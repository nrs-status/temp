{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.typescript;
in 
  {
  options.${osConfig.networking.hostName}.home.typescript.enable = lib.mkEnableOption "typescript-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        typescript
        nodePackages_latest.ts-node
      ];
    };

 };
}
