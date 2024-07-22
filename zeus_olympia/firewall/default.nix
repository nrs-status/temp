{
  config,
  lib,
  pkgs,
  nixosVars,
  ...
}: let
  cfg = config.${nixosVars.hostName}.system.firewall;
in {
  options.${nixosVars.hostName}.system.bluetooth.enable = lib.mkEnableOption "firewall";

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [8081];
      };
    };
    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez
      blueman
    ];

    home-manager = lib.mkIf config.${nixosVars.hostName}.system.home-manager.enable {
      users.${nixosVars.mainUser}.${nixosVars.hostName}.home.waybar.bluetoothModule.enable = true;
    };

    # passwordless access to rfkill without sudo so bluetooth can be toggled
    security.sudo.extraRules = [
      {
        groups = ["wheel"];
        commands = [
          {
            command = "/run/current-system/sw/bin/rfkill";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
