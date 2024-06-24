{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.docker;
in
{
  options.${nixosVars.hostName}.system.docker.enable = lib.mkEnableOption "Enable rootless docker";
  config = lib.mkIf cfg.enable { 
       assertions = [
    {
       assertion = !config.${nixosVars.hostName}.system.podman.enable;
       message = "Attempting to enable docker nixOS module yet podman nixOS module is already enabled";
     }
   ];

     virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
   };
}
