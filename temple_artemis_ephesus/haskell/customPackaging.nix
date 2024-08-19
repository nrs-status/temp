{pkgs, ...}: 
let 
        obeliskDerivation = pkgs.fetchzip {
        url = "https://github.com/obsidiansystems/obelisk/archive/master.tar.gz";
        hash = "sha256-GxzOAcv/db0we74A2T2PgReLaf6ZU/z3vqFGHRO9IDc=";
      };
      obeliskBuild = pkgs.callPackage obeliskDerivation {};
in
  {
    obelisk = obeliskBuild.command;
}
