{pkgs, ...}: {
  cljstyle = pkgs.stdenv.mkDerivation {
    name = "cljstyle";
    version = "0.16.626";

    src = pkgs.fetchzip {
      url = "https://github.com/greglook/cljstyle/releases/download/0.16.626/cljstyle_0.16.626_linux_amd64.zip";
      hash = "sha256-bvxCWmn71F6wdCXxnnkXoHSV8DDPwxh+fcp8h0uDmj8=";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];

    buildInputs = with pkgs; [
      zlib
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp $src/cljstyle $out/bin/cljstyle
      chmod +x $out/bin/cljstyle

      runHook postInstall
    '';
  };
}
