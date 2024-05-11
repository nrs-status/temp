{ config, lib, pkgs, nixosVars, ... }:

let 
  cfg = config.${nixosVars.hostName}.system.bluetooth;
in {
  options.${nixosVars.hostName}.system.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez
      blueman
    ];

    #home-manager.users.${nixosVars.mainUser}.${nixosVars.hostName}.home.waybar.bluetoothModule.enable = true;


    # passwordless access to rfkill without sudo so bluetooth can be toggled
    security.sudo.extraRules = [{
      groups = [ "wheel" ];
      commands = [{
        command = "/run/current-system/sw/bin/rfkill";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
