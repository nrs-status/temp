{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.gammastep;
in {
  options.${osConfig.networking.hostName}.home.gammastep.enable = lib.mkEnableOption "Gammastep";
  config = lib.mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      provider = "manual";
      latitude = -27.5;
      longitude = -59.0;
    };
 #   services.redshift = {
 #     enable = true;
 #     temperature = {
 #       day = 5500;
 #       night = 3700;
 #     };
 #   };
  };
}
