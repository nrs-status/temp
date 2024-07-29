{pkgs, ...}: {
  swayrst = pkgs.stdenv.mkDerivation {
    name = "swayrst";
    version = "5a73abb";

    src = ./resources/packages/swayrst;

    #phases must be explicitly declared otherwise will run an unpack phase that will attempt to extract the source
    phases = ["installPhase"];

    #autoPatchelHook is used to patch link dependencies that the executable requires in order to run
    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    #links to be patched go here; use ldd and objectdump -x to figure out which ones should come here
    buildInputs = with pkgs; [
      libz
      glibc
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/swayrst $out/bin/swayrst
      chmod +x $out/bin/swayrst
    '';
  };
}
