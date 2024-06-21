{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.etc;
in 
  {
  options.${osConfig.networking.hostName}.home.etc.enable = lib.mkEnableOption "packages that don't fit elsewhere";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        distrobox
        ventoy #bootable usb maker
        vesktop #discord client
        anydesk #remote desk client
        twilio-cli #for work with fede
      ];
    };

 };
}
