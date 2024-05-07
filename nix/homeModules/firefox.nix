{
  config,
  lib,
  pkgs,
  osConfig,
  nixosVars,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.firefox;
in {
  options.${osConfig.networking.hostName}.home.firefox.enable = lib.mkEnableOption "Firefox";
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.nineveh = {
        isDefault = true;
        settings = {
          #opt out of studies
          "app.shield.optoutstudies.enabed" = false;

          #strict tracking protection
          "browser.contentblocking.category" = "strict";

          #https-only mode
          "dom.security.https_only_mode" = true;

          #Warn on quit
          "browser.sessionstore.warnOnQuit" = true;
        };
      };

      policies = {
        DownloadDirectory = "/home/${nixosVars.mainUser}/downloads";
        #DefaultDownloadDirectory = "/home/sieyes/downloads";
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # gruvbox theme:
          "{eb8c4a94-e603-49ef-8e81-73d3c4cc04ff}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/gruvbox-dark-theme/latest.xpi";
            installation_mode = "force_installed";
          };
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };
  };
}
