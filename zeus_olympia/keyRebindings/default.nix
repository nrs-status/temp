{
  config,
  lib,
  pkgs,
  nixosVars,
  ...
}: let
  cfg = config.${nixosVars.hostName}.system.keyRebindings;
in {
  options.${nixosVars.hostName}.system.keyRebindings.enable = lib.mkEnableOption "Key rebindings";
  config = lib.mkIf cfg.enable {
    services = {
      keyd = {
        enable = true;
        keyboards = {
          default = {
            ids = ["*"];
            settings = {
              main = {
                "4" = "e";
                leftcontrol = "0";
                rightcontrol = "layer(custom)";
                rightalt = "#";
                capslock = "leftcontrol";
                "f" = "overload(shift, f)";
              };
              "custom:S" = {
                #see man keyd for explanation
                rightalt = "$";
              };
            };
          };
        };
      };
    };
  };
}
