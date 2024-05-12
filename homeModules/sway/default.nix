{ config, lib, pkgs, osConfig, ... }:

let
  gruvbox = import ./gruvboxColors.nix;
  cfg = config.${osConfig.networking.hostName}.home.sway;
in {
  options.${osConfig.networking.hostName}.home = { 
    sway.enable = lib.mkEnableOption "Firefox";
    waybar.bluetoothModule.enable = lib.mkEnableOption "Enable the bluetooth module in Waybar";
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        grim # screenshot functionality, alternatively try 'slurp'
        wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
        mako # notification system developed by swaywm maintainer
        wev #xev analogue
      ];
    };

    programs = { 
      waybar = {#needs to be enabled in wayland.windowManager.sway.config.bars
      enable = true;
        package = pkgs.waybar;
        settings = [{
         # layer = "top";
         start_hidden = true;

      modifier = "Mod4";
         hidden_state = "hide";
         modifier-reset = "press";
         position = "top";
         ipc = true;
         layer = "top";
          height = 35;
          mode = "hide";
          modules-left =
            [ "sway/workspaces" "sway/mode" "idle_inhibitor" ]; 
            modules-right = [ "backlight" "battery"  "network" ]
            ++ lib.optional config.${osConfig.networking.hostName}.home.waybar.bluetoothModule.enable "bluetooth" #enabled through nixosModules/bluetooth.nix
            ++ [ "pulseaudio" "clock" ];
            "sway/workspaces".numeric-first = true;
           pulseaudio = {
              on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
              on-click-right =
                "${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";
              format-icons = {
                # TODO bluetooth + muted icons? (needs support upstream?)
                car = "󰄋";
                handsfree = "󰋎";
                hdmi = "󰡁";
                headphones = "󰋋";
                headset = "󰋎";
                hifi = "󰗜";
                phone = "󰏶";
                portable = "󰏶";
                default = [ "󰕿" "󰖀" "󰕾" ];
              };
              format = "{icon}{volume:3}%";
              format-bluetooth = "{icon}󰂯{volume:3}%";
              format-muted = "󰝟{volume:3}%";
            };
            backlight = {
              format = "{icon}";
              format-icons = [ "󰛩" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨" ];
              on-scroll-up = "${pkgs.light}/bin/light -A 10";
              on-scroll-down = "${pkgs.light}/bin/light -U 10";
              on-click-right = "${pkgs.light}/bin/light -S 100";
              on-click-middle = "${pkgs.light}/bin/light -S 0";
            };
            network = {
              format-wifi = "{icon}";
              interval = 20;
              format-ethernet = "󰈀";
              format-linked = "󰌷";
              format-icons = [ "󰤫" "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
              format-disconnected = "󰤮";
              on-click =
                "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
              tooltip-format =
                "󰩟{ipaddr} 󰀂{essid} {frequency} {icon}{signalStrength} 󰕒{bandwidthUpBits} 󰇚{bandwidthDownBits}";
            };
            bluetooth = {
              format-icons = {
                disabled = "󰂲";
                enabled = "󰂯";
              };
              format = "{icon}";
              on-click = "${pkgs.blueman}/bin/blueman-manager";
              on-click-right = "${pkgs.utillinux}/bin/rfkill toggle bluetooth";
            };
            battery = {
              format = "{icon}";
              rotate = 270;
              # TODO set different icons when charging (currently broken?)
              format-icons = [ "󱃍" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
              states = {
                critical = 10;
                warning = 30;
              };
              tooltip-format = "{timeTo} - {capacity}%";
              tooltip = "true";
            };
            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "󰅶";
                deactivated = "󰾪";
              };
            };
            clock = {
              interval = 1;
              format = "󰅐 {:%T}";
              tooltip-format = "{:%F}";
            };          
          }];
          style = import ./waybarStyle.nix;
      };
    };

    wayland.windowManager.sway = 
      let
        lockCommand = lib.concatStringsSep " " (with gruvbox;
          let rO = lib.removePrefix "#"; # remove Octothorpe
          in [
            "exec ${pkgs.swaylock-effects}/bin/swaylock"
            "--screenshots"
            "--clock"
            "--indicator"
            "--fade-in 1"
            "--font 'Iosevka'"
            "--inside-color ${rO dark.bg}"
            "--inside-clear-color ${rO light.yellow.bright}"
            "--inside-caps-lock-color ${rO light.orange.bright}"
            "--inside-ver-color ${rO light.purple.bright}"
            "--inside-wrong-color ${rO light.red.bright}"
            "--key-hl-color ${rO dark.cyan.bright}"
            "--line-color ${rO dark.bg}"
            "--line-clear-color ${rO dark.bg}"
            "--line-caps-lock-color ${rO dark.bg}"
            "--line-ver-color ${rO dark.bg}"
            "--line-wrong-color ${rO dark.bg}"
            "--ring-color ${rO light.cyan.bright}"
            "--ring-clear-color ${rO dark.yellow.bright}"
            "--ring-caps-lock-color ${rO dark.orange.bright}"
            "--ring-ver-color ${rO dark.purple.bright}"
            "--ring-wrong-color ${rO dark.red.normal}"
            "--separator-color ${rO dark.bg}"
            "--text-color ${rO dark.fg}"
            "--text-clear-color ${rO dark.fg}"
            "--text-caps-lock-color ${rO dark.fg}"
            "--text-ver-color ${rO dark.fg}"
            "--text-wrong-color ${rO dark.fg}"
            "--effect-pixelate 15"
            "--effect-blur 7x5"
          ]);
      in
    {
      enable = true;
      config = {
        bars = [{ command = "${pkgs.waybar}/bin/waybar && swaymsg bar mode hide bar-0 "; }];
       
        colors = {
            background = gruvbox.dark.bg;
            focused = {
              background = gruvbox.dark.bg;
              border = gruvbox.dark.bg;
              childBorder = gruvbox.dark.bg2;
              indicator = gruvbox.dark.bg4;
              text = gruvbox.dark.fg;
            };
            focusedInactive = {
              background = gruvbox.dark.bg;
              border = gruvbox.dark.bg;
              childBorder = gruvbox.dark.bg0_h;
              indicator = gruvbox.dark.bg0_h;
              text = gruvbox.dark.gray;
            };
            "placeholder" = {
              background = gruvbox.dark.bg0_s;
              border = gruvbox.dark.bg0_s;
              childBorder = gruvbox.dark.bg0_s;
              indicator = gruvbox.dark.bg0_s;
              text = gruvbox.dark.fg;
            };
            unfocused = {
              background = gruvbox.dark.bg2;
              border = gruvbox.dark.bg;
              childBorder = gruvbox.dark.bg0_h;
              indicator = gruvbox.dark.bg0_h;
              text = gruvbox.dark.gray;
            };
            urgent = {
              background = gruvbox.light.red.normal;
              border = gruvbox.light.red.normal;
              childBorder = gruvbox.light.red.normal;
              indicator = gruvbox.light.red.normal;
              text = gruvbox.dark.fg;
            };
          };
        floating = {
            border = 4;
            titlebar = true;
          };
        fonts = {
            names = [ "Iosevka Proportional" ];
            size = 11.0;
          };
        focus.followMouse = false;
        modifier = "Mod4";
        terminal = "${pkgs.kitty}/bin/kitty";
        window = {
            border = 1;
            commands = [
              {
                criteria = { app_id = "kitty"; };
                command = "opacity 0.90";
              }
              {
                criteria = { class = "(?i)(emacs)"; };
                command = "opacity 0.90";
              }
            ];
          };
          workspaceAutoBackAndForth = true;
      };
    };
  };
}
