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
    preparePatch = patch: hash:
      fetchpatch {
        url = "file://${src}/llm/patches/${patch}";
        inherit hash;
        stripLen = 1;
        extraPrefix = "llm/llama.cpp/";
      };

    llamacppPatches = [
      (preparePatch "01-load-progress.diff" "sha256-UTmnBS5hQjIL3eXDZc8RBDNJunLlkqJWH20LpXNiGRQ=")
      (preparePatch "02-clip-log.diff" "sha256-rMWbl3QgrPlhisTeHwD7EnGRJyOhLB4UeS7rqa0tdXM=")
      (preparePatch "03-load_exception.diff" "sha256-NJkT/k8Mf8HcEMb0XkaLmyUNKV3T+384JRPnmwDI/sk=")
      (preparePatch "04-metal.diff" "sha256-bPBCfoT3EjZPjWKfCzh0pnCUbM/fGTj37yOaQr+QxQ4=")
      (preparePatch "05-default-pretokenizer.diff" "sha256-Mgx+xi59rz3d5yEXp90QPQMiUr9InlA0Wo1mOSuRcec=")
      (preparePatch "06-embeddings.diff" "sha256-lqg2SI0OapD9LCoAG6MJW6HIHXEmCTv7P75rE9yq/Mo=")
      (preparePatch "07-clip-unicode.diff" "sha256-1qMJoXhDewxsqPbmi+/7xILQfGaybZDyXc5eH0winL8=")
      (preparePatch "08-pooling.diff" "sha256-7meKWbr06lbVrtxau0AU9BwJ88Z9svwtDXhmHI+hYBk=")
      (preparePatch "09-lora.diff" "sha256-HVDYiqNkuWO9K7aIiT73iiMj5lxMsJC1oqIG4madAPk=")
      (preparePatch "10-params.diff" "")
      (preparePatch "11-phi3-sliding-window.diff" "")
    ];
  });
}
