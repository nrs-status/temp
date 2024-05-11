{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.multimedia;
in {
  options.${osConfig.networking.hostName}.home.multimedia.enable = lib.mkEnableOption "Multimedia";
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        #ebooks
        okular
        calibre

        #image
        imagemagick

        #video
        streamlink

        #general
        ffmpeg-full
      ];
    };
  };
}
