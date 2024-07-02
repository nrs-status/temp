{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.multimedia;
in {
  options.${osConfig.networking.hostName}.home.multimedia.enable = lib.mkEnableOption "Multimedia";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        #ebooks
        okular
        calibre
        pandoc

        #image  -- imagemagick, imv, and feh are all meant for the same use. they are all enabled while i try them out
        imagemagick
        imv
        feh
        gimp

        #video
        streamlink
        vlc
        yt-dlp

        #general
        ffmpeg-full
      ];
    };
  };
}
