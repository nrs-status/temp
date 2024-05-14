{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.fish;
in
{
  options.${nixosVars.hostName}.system.fish.enable = lib.mkEnableOption "Key rebindings";
  config = lib.mkIf cfg.enable { 
    programs.fish = {
      enable = true;

      interactiveShellInit = ''

      #don't greet
      function fish_greeting; end

      #use vi bindings
      set -g fish_key_bindings fish_vi_key_bindings
      #emulate vim's cursor shape behaviour
      set -g fish_vi_force_cusor 1
      #set the normal and visual mode cursors to a block
      set fish_cursor_default block
      #set the insert mode cursor to a line
      set fish_cursor_insert line
      #set the replace mode cursors to an underscore
      set fish_cursor_replace_one underscore
      set fish_cursor_replace underscore
      '';
#      function sudo -d "sudo wrapper that handles aliases"
#        if functions -q -- $argv[1]
#          set -l new_args (string join ' ' -- (string escape -- $argv))
#          set argv fish -c "$new_args"
#        end
#
#        command sudo $argv
#      end
#      '';

      shellAliases = {
        cp = "cp -riv";
        mv = "mv -iv";
        rm = "trash";
        getpublicip = "curl https://api.ipify.org";
        rb = "sudo rb";
        se = "sudoedit";
        mkdir = "mkdir -pv";

        icat = "kitty +kitten icat";
        py = "python";

        c = "printf \"\\033c\"";
        clear =  "printf \"\\033c\"";
      };

      shellAbbrs = {
        g = "git";
        gc = "git commit -m";
        
        zhm = "cd /etc/nixos/temple_artemis_ephesus";
        zn = "cd /etc/nixos";
        znm = "cd /etc/nixos/zeus_olympia";
        ze = "cd /etc/nixos/hanging_gardens_babylon";

        tl = "trash-list";

        j = "yazi";

      };
    };

    environment.systemPackages = with pkgs; [
     # fishPlugins.plugin-git.src
     # fishPlugins.bass.src
    ];
  };
}
