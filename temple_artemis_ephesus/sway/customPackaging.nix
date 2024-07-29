{pkgs, ...}: {
  swayrst = pkgs.stdenv.mkDerivation {
    name = "swayrst";
    version = "5a73abb";

    src = ./resources/packages/swayrst;

    phases = ["installPhase"];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/swayrst $out/bin/swayrst
      chmod +x $out/bin/swayrst
    '';
  };
}
