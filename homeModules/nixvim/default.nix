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
      
      viAlias = true;
      vimAlias = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      clipboard.providers.wl-copy.enable = true;

      colorschemes.gruvbox.enable = true;

      keymaps = [
        {
          action = ":q";
          key = "<Leader>q";
        }
        {
          action = ":Telescope find_files<CR>";
          key = "<Leader>ff";
        }
        {
          action = ":Telescope live_grep<cr>";
          key = "<leader>lg";
        }
      ];

      opts = {
        number = true; # Show line numbers
        relativenumber = true; # Show relative line numbers

        mouse = "a"; # Enable mouse control
        mousemodel = "extend"; # Mouse right-click extends the current selection

        shiftwidth = 2; # Tab width should be 2

        swapfile = false; # Disable the swap file
        modeline = true; # Tags such as 'vim:ft=sh'
        modelines = 100; # Sets the type of modelines
        undofile = true; # Automatically save and restore undo history
        incsearch = true; # Incremental search: show match for partly typed search command
        inccommand = "split"; # Search and replace: preview changes in quickfix list
        ignorecase = true; # When the search query is lower-case, match both lower and upper-case
        #   patterns
        smartcase = true; # Override the 'ignorecase' option if the search pattern contains upper
        #   case characters
        scrolloff = 8; # Number of screen lines to show around the cursor
        cursorline = true; # Highlight the screen line of the cursor
        cursorcolumn = true; # Highlight the screen column of the cursor
      };
      plugins = {
        telescope = { 
          enable = true;
          extensions.fzf-native.enable = true;
        };
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
