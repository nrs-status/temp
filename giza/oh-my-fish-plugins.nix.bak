{ pkgs
, stdenv
, omf
, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "oh-my-fish-plugins";
  version = "unversioned";

  buildInputs = [
    omf
  ];

  installPhase = ''
    omf install kawasaki
    '';
})
