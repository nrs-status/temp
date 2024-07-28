{
  pkgs,
  system,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "swayrst";
  version = "5a73abb";
  src = pkgs.fetchurl {
    url = "https://github.com/Nama/swayrst/actions/runs/10133974389/artifacts/1748481274";
    sha256 = "";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/swayrst
    chmod +x $out/bin/swayrst
  '';
}
