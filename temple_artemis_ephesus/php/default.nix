{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.php;
in 
  {
  options.${osConfig.networking.hostName}.home.php.enable = lib.mkEnableOption "PHP-related packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        php
        phpunit #unit testing for php
        php82Packages.composer #dependency manager for php
      ];
    };

 };
}
