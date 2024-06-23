{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.podman;
in
{
  options.${nixosVars.hostName}.system.podman.enable = lib.mkEnableOption "Enable podman";
  config = lib.mkIf cfg.enable { 
     virtualisation.podman = {
      enable = true;
      dockerCompat = true; #alias 'docker' so podman can act as drop-in replacement
    };
   };
}
