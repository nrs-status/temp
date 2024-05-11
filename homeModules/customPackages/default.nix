{ config, lib, pkgs, osConfig, ... }:

let 
  cfg = config.${osConfig.networking.hostName}.home.custom_packages;
in {
  options.${osConfig.networking.hostName}.home.custom_packages.enable = lib.mkEnableOption "Custom Packages";
  config = lib.mkIf cfg.enable {
    home = {
      packages = let
        utils = import ../../utils;
        customPackagesPaths = utils.getNixFiles {
          dir = ../customPackages;
          ignore = [];
        };
        nameNPackagePairFromPackagePath = path:  
        let
          package = callPackage path {};
        in
          { package.pname = package; };
        callPackage = lib.callPackageWith ( pkgs // customPackages );
        customPackages = lib.listToAttrs (map nameNPackagePairFromPackagePath customPackagesPaths);
      in
        map callPackage customPackagesPaths;
    };
  };
}

