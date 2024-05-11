{
  config,
  lib,
  pkgs,
  osConfig,
  nixosVars,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.nixvim;
in {
  options.${osConfig.networking.hostName}.home.nixvim.enable = lib.mkEnableOption "nixvim";
  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables.EDITOR = "nvim";
      packages = with pkgs; [
        alejandra #for formatting nix
      ];
    };

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      globals.mapleader = " ";

      clipboard.providers.wl-copy.enable = true;

      colorschemes.gruvbox.enable = true;

      opts = {
        number = true; # Show line numbers
        relativenumber = true; # Show relative line numbers

        shiftwidth = 2; # Tab width should be 2
        highlight = {
          Comment.fg = "#ff00ff";
          Comment.bg = "#000000";
          Comment.underline = true;
          Comment.bold = true;
        };
      };
      plugins = {
        cmp = {
          enable = true;
          autoEnableSources = true;
          #      sources = [
          #        {name = "nvim_lsp";}
          #        {name = "path";}
          #        {name = "buffer";}
          #        {name = "luasnip";}
          #      ];
        };

        lsp = {
          enable = true;

          servers = {
            tsserver.enable = true;

            lua-ls = {
              enable = true;
              settings.telemetry.enable = false;
            };
          };
        };
      };
    };
  };
}
