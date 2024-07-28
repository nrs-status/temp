{
  config,
  lib,
  pkgs,
  nixosVars,
  ...
}: let
  cfg = config.${nixosVars.hostName}.system.numlockOnBoot;
in {
  options.${nixosVars.hostName}.system.numlockOnBoot.enable = lib.mkEnableOption "enable numlock on boot";

  config = lib.mkIf cfg.enable {
    boot.initrd.preLVMCommands = ''
      ${pkgs.kbd}/bin/setleds +num
      '';
      };
    };
}
