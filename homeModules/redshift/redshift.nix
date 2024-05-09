{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.redshift;
in {
  options.${osConfig.networking.hostName}.home.redshift.enable = lib.mkEnableOption "Redshift";
  config = lib.mkIf cfg.enable {
    services.redshift = {
      enable = true;
      temperature = {
        day = 5500;
        night = 3700;
      };
    };
  };
}
