{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.bluetooth;
in {
  options.${osConfig.networking.hostName}.home.bluetooth.enable = lib.mkEnableOption "Bluetooth";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        bluez
        blueman
      ];
    };

    ${osConfig.networking.hostName}.home.waybar.bluetoothModule.enable = true; #defined in sway.nix
    services.blueman-applet.enable = true;
  };
}
