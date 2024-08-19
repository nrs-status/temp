{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.etc;
in
{
  options.${nixosVars.hostName}.system.etc.enable = lib.mkEnableOption "etc";
  config = lib.mkIf cfg.enable { 
    #these are used to make obelisk build faster
    nix.binaryCaches = [ "https://nixcache.reflex-frp.org" ];
    nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];


    };
}
