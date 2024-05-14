{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.vault-secrets;
in
{
  options.${nixosVars.hostName}.system.vault-secrets.enable = lib.mkEnableOption "hashicorp vault secrets management";
  config = lib.mkIf cfg.enable { 
    vault-secrets = {
      vaultPrefix = "kv/${nixosVars.hostName}";
      vaultAddress = "https://${nixosVars.vaultHost}:${nixosVars.vaultHostPort}";

      secrets.restic = {}; 
    };
    #suppose we also have the following line in our service conf: environmentFile = "${config.vault-secrets.secrets}/environment";

  # then the above will query kv/hostname/environment and kv/hostname/secrets; any keys defined in environment will be dumped into /run/secrets/restic/environment; any keys defined in secrets will be dumped into /run/secrets/restic  
  };
}
