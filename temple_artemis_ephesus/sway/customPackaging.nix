{pkgs, ...}: {
  swayrst = pkgs.stdenv.mkDerivation {
    name = "swayrst";
    version = "5a73abb";

    src = ./resources/packages/swayrst;

    #phases must be explicitly declared otherwise will run an unpack phase that will attempt to extract the source
    phases = ["installPhase" "fixupPhase" "postBuild"];

    nativeBuildInputs = [
      pkgs.autoPatchelfHook #autoPatchelHook is used to patch link dependencies that the executable requires in order to run
      pkgs.makeBinaryWrapper # used by wrapProgram
    ];

    #links to be patched go here; use ldd and objectdump -x to figure out which ones should come here
    buildInputs = with pkgs; [
      zlib
      glibc
      libnotify
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp $src/swayrst $out/bin/swayrst
      chmod +x $out/bin/swayrst

      runHook postInstall
    '';

    postBuild = ''
      wrapProgram $out/bin/swayrst \
        --set PATH ${pkgs.lib.makeBinPath [pkgs.libnotify]}
    '';
  };
}
