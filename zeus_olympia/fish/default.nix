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
      function sudo -d "sudo wrapper that handles aliases"
        if functions -q -- $argv[1]
          set -l new_args (string join ' ' -- (string escape -- $argv))
          set argv fish -c "$new_args"
        end

        command sudo $argv
      end
      '';

      shellAliases = {
        cp = "cp -riv";
        mv = "mv -iv";
        rm = "trash";
        getpublicip = "curl https://api.ipify.org";
        rb = "sudo rb";
        se = "sudoedit";
      };

      shellAbbrs = {
        g = "git";
        gc = "git commit -m";
        
        zhm = "cd /etc/nixos/temple_artemis_ephesus";
        zn = "cd /etc/nixos";
        znm = "cd /etc/nixos/zeus_olympia";
        ze = "cd /etc/nixos/hanging_gardens_babylon";

        tl = "trash-list";

        c = "clear";
        j = "yazi";

      };
    };
  };
}
