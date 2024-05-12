{
  homeVars = {
    #	mainUser = "sieyes";
    #	mainUserHomeDir = "/home/sieyes";
    pkgSets = [
      #the following configs from the homeModules directory will be enabled; it uses the filename in homeModules without the .nix suffix
      #"core"
      "cli"
      "git"
      "nixvim"
      "firefox"
      "multimedia"
      "games"
      "sway"
      "kitty"
      "fonts"
      #"bluetooth"
      "etc"
      "gammastep"
      "cloudwork"
      #"custom_packages"
    ];
  };
  nixosVars = {
    hostName = "nineveh";
    system = "x86_64-linux";
    timeZone = "America/Argentina/Buenos_Aires";
    mainUser = "sieyes";
    mainUserHomeDir = "/home/sieyes";

    modulesToEnable = [
      "home-manager"
      "keyRebindings"
      "bluetooth"
    ];
  };
}
