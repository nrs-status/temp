{ config, lib, pkgs, osConfig, ... }:

let cfg = config.${osConfig.networking.hostName}.home.kitty;
in {
  options.${osConfig.networking.hostName}.home.kitty.enable = lib.mkEnableOption "Kitty Terminal Emulator";
  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka";
      };
      theme = "Gruvbox Dark";
      shellIntegration.enableFishIntegration = true;
      settings = {
        bold_font = "Iosevka Semibold";
        italic_font = "Iosevka Light Italic";
        bold_italic_font = "Iosevka Semibold Italic";

        cursor_blink_interval = "0.5";
        cursor_stop_blinking_after = 15;
        enable_audio_bell = false;
        scrollback_lines = 5000;
        scrollback_fill_enlarged_window = true;
        remember_window_size = false;
        disable_ligatures = "always";
        symbol_map = "U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d4,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f532,U+f0001-U+f1af0 Symbols Nerd Font Mono";
        touch_scroll_multiplier = 3;
        mouse_hide_wait = 0;
        input_delay = 1;
        repaint_delay = 8;
      };
    };
  };
}
