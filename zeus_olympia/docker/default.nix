{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.docker;
in
{
  options.${nixosVars.hostName}.system.docker.enable = lib.mkEnableOption "Enable rootless docker";
  config = lib.mkIf cfg.enable { 
     virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
   };
}
