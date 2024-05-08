{ pkgs, customPackage, ... }:
pkgs.stdenv.mkDerivation {
  name = "atest";
  buildCommand = ''
    touch $out
  '';
}

