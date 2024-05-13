{ config, lib, pkgs, nixosVars, vault, ... }:

let
  cfg = config.${nixosVars.hostName}.system.restic;
in
{
  options.${nixosVars.hostName}.system.restic.enable = lib.mkEnableOption "restic";
  config = lib.mkIf cfg.enable { 
    services.restic.backups.qinshihuang = {
      user = nixosVars.mainUser;
      repository = "rest:http://${nixosVars.backupHost}:${nixosVars.backupHostPort}/";
      passwordFile = vault.resticRepoPasswordFile; #depending on how vault setup work, check whether it is not worthwhile using env vars instead. see restic.readthedocs.io for info about how env vars pass the password
      paths = [ 
        "${nixosVars.mainUserHomeDir}/taylor1911"
        "/etc/nixos"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
      extraBackupArgs = [ 
        "--exclude-larger-than 15M" #see restic's readthedocs under 'backing up''
        "--compression max"
      ];
    };

  };
}
