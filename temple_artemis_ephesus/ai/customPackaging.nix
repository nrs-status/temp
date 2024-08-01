{pkgs, ...}: {
  ollama = pkgs.ollama.overrideAttrs (old: rec {
    version = "0.3.2";
    src = pkgs.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "v${version}";
      hash = "";
      fetchSubmodules = true;
    };
  });
}
