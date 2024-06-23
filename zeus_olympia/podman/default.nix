{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.podman;
in
{
  options.${nixosVars.hostName}.system.podman.enable = lib.mkEnableOption "Enable podman";
  config = lib.mkIf cfg.enable { 

    assertions = [
      {
        assertion = !config.${nixosVars.hostName}.system.docker.enable;
        message = "Attempting to enable podman nixOS module yet docker nixOS module is already enabled";
      }
    ];

     virtualisation.podman = {
      enable = true;
      dockerCompat = true; #alias 'docker' so podman can act as drop-in replacement
      defaultNetwork.settings = {
      dns_enabled = true;
      ipv6_enabled = true;
    };

    };
   };
}
