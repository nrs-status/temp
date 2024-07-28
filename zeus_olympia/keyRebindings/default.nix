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
                meta = "";
                "f" = "overloadt(shift, f, 130)";
                "h" = "overloadt(shift, h, 130)";
                "j" = "overloadt(meta, j, 130)";
                "d" = "overloadt(meta, d, 130)";
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
