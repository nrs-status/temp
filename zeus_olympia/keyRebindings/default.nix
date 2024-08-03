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
                meta = "layer(custom2)";
                "f" = "overloadt(shift, f, 130)";
                "h" = "overloadt(shift, h, 130)";
                "j" = "overloadt(meta, j, 130)";
                "d" = "overloadt(meta, d, 130)";

                "1" = "!";
                "2" = "@";
                "5" = "%";
                "6" = "^";
                "7" = "&";
                "8" = "*";
                "9" = "(";
                "0" = ")";
              };
              "custom:S" = {
                #see man keyd for explanation
                rightalt = "$";
              };
              "custom2:211" = {
                "kp1" = "1";
                "kp2" = "2";
                "kp3" = "3";
                "kp4" = "4";
                "kp5" = "5";
                "kp6" = "6";
                "kp7" = "7";
                "kp8" = "8";
                "kp9" = "9";
                "kp0" = "0";
              };
            };
          };
        };
      };
    };
  };
}
