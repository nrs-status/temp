{ pkgs, stdenv, ... }:
stdenv.mkDerivation (finaltAttrs: {
  pname = "customPackage";
  version = "unversioned";
  src = ./.;
  buildCommand = ''
    touch $out
    '';

  buildPhase = ''
    touch dasFile.filation
    echo "hello"
    '';
})
