{
  system = "x86_64-linux";
  modules = [
    (
      { config, lib, pkgs, ... }:
      {
        home = {
          username = "sieyes";
          homeDirectory = "/home/sieyes";
          stateVersion = "23.11";
        };

        nineveh.home = {
          core.enable = true;
        };
      }
    )
  ];
}

