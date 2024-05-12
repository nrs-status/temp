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
        #number = true; # Show line numbers
        relativenumber = true; # Show relative line numbers

        viAlias = true;
        vimAlias = true;

        shiftwidth = 2; # Tab width should be 2
        highlight = {
          Comment.fg = "#ff00ff";
          Comment.bg = "#000000";
          Comment.underline = true;
          Comment.bold = true;
        };
      };
      plugins = {
        telescope.enable = true;
        rainbow-delimiters.enable = true;
        nix.enable = true;
        sleuth.enable = true;
        surround.enable = true;

        cmp = {
          enable = true;
          autoEnableSources = true;
        };

        cmp-nvim-lsp.enable = true;
        cmp-nvim-lua.enable = true;
        cmp-rg.enable = true;
        cmp-treesitter.enable = true;
        cmp-zsh.enable = true;

        comment.enable = true;

        gitsigns.enable = true;

        indent-blankline = {
          enable = true;
          settings = {
            exclude = {
              buftypes = ["terminal" "nofile"];
              filetypes = ["help"];
            };
          };
        };

        lualine.enable = true;

        neogit.enable = true;

        lsp = {
          enable = true;

          servers = {
            tsserver.enable = true;
            dagger.enable = true;

            clangd.enable = true;

            dockerls.enable = true;

            ruff-lsp.enable = true;

            terraformls.enable = true;

            sqls.enable = true;

            yamlls.enable = true;

            gopls.enable = true;

            helm-ls.enable = true;
            hls.enable = true;
            java-language-server.enable = true;

            lua-ls = {
              enable = true;
              settings.telemetry.enable = false;
            };
          };
        };

        treesitter = {
          enable = true;
        };
      };
    };
  };
}
