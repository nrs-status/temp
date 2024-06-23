{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.vault-server;
in
{
  options.${nixosVars.hostName}.system.vault-server.enable = lib.mkEnableOption "vault server container";
  config = lib.mkIf cfg.enable { 
    assertions = [
      {
      assertion = config.${nixosVars.hostName}.system.docker.enable;
      message = "vault-server option requires docker to start vault server container";
    }
    ];
    virtualisation = {
    oci-containers = {
      backend = "docker";
      containers.vault = {
        image = "hashicorp/vault";
        ports = [
          "443:443"
        ];
        volumes = [
          "/etc/nixos/zeus_olympia/vault-server/config:/vault/config:z"
        ];
        extraOptions = [
          "--cap-add=IPC_LOCK"
        ];
        cmd = [
          "server"
        ];
      };

    };
  };

  };
}
