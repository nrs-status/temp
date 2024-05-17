{ config, lib, pkgs, nixosVars, ... }:

let
  cfg = config.${nixosVars.hostName}.system.fish;
in
{
  options.${nixosVars.hostName}.system.fish.enable = lib.mkEnableOption "Key rebindings";
  config = lib.mkIf cfg.enable { 
    programs.fish = {
      enable = true;
#
#      package = pkgs.fish.override {
#        fishEnvPreInit = "" 
#      };
#
      shellInit = '' function sudo -d "sudo wrapper that handles aliases"
        if functions -q -- $argv[1] #checks if the first argument to sudo is a function. the -q option makes the `functions` command run quietly with no outputt
          set -l new_args (string join ' ' -- (string escape -- $argv)) #set -l defines a local variable which remains local to the function. in this case; the function "sudo". this line creates a new string from the arguments coming after the function passed to sudo
          set argv fish -c "$new_args" # this line modifies the argv array. in combination with the coming "command" command, it will dictate exactly what will be executed by the function
        end

        command sudo $argv # executes the command sudo along with the arguments passed
      end'';

      interactiveShellInit = ''
      #envvars
      set -gx t /tmp/file #for saving outputs

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

      shellAliases = {
        cp = "cp -riv";
        mv = "mv -iv";
        rm = "trash";
        rb = "sudo rb";
        se = "sudoedit";
        mkdir = "mkdir -pv";
        ls = "eza";
        ll = "eza -l";

        
        nvi = "navi --fzf-overrides \"--height 40%\" --fzf-overrides-var \"--height 40%\"";
        nvipi = "nvi --print --prevent-interpolation";
        nvit = "nvipi | tee /tmp/file";
        navipi = "navi --print --prevent-interpolation";
        navit = "navipi | tee /tmp/file";
        t = "cat /tmp/file";

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
        zc = "cd /etc/nixos/temple_artemis_ephesus/navi/cheatsheets";

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
