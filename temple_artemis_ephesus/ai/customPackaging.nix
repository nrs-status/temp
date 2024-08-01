{pkgs, ...}: {
  ollama = pkgs.ollama.overrideAttrs (old: rec {
    version = "0.3.2";
    src = pkgs.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "v${version}";
      hash = "sha256-EI3dQcsvv8T4lYNcWML8SesOQfAkCEsZvd+C3S+MY5o=";
      fetchSubmodules = true;
    };
  });
}
