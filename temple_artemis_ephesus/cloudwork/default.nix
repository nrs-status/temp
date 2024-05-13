{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.cloudwork;
in {
  options.${osConfig.networking.hostName}.home.cloudwork.enable = lib.mkEnableOption "cloudwork";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        google-cloud-sdk
        terraform
        terragrunt
      ];
    };
  };
}
