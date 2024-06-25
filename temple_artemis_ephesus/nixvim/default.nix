{
  config,
  lib,
  pkgs,
  osConfig,
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
    
      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };
      colorschemes.gruvbox.enable = true;

      keymaps = [
        {
          action = ":noh<CR><Esc>";
          key = "<Esc>";
        }
        {
          action = ":q<cr>";
          key = "<Leader>qq";
        }
        {
          action = "<Esc>:q<cr>";
          key = "<leader>qq";
          mode = [ "i" ];
        }
        {
          action = ":wq<cr>";
          key = "<Leader>wq";
        }
        {
          action = ":q!<cr>";
          key = "<leader>q1";
        }
        {
          action = ":w<cr>";
          key = "<leader>ww";
        }
        {
          action = ":Telescope find_files<CR>";
          key = "<Leader>ff";
        }
        {
          action = ":Telescope live_grep<cr>";
          key = "<leader>lg";
        }
        {
          action = "<Esc>";
          key = " jk";
          mode = [ "i" ]; 
        }
        {
          action = "<Cmd>Neotree toggle<CR>";
          key = "<leader>n";
        }
        {
          action = "vim.lsp.buf.hover";
          key  = "<leader>k";
          mode = [ "n" ];
        }
        {
          action = "vim.lsp.buf.definition";
          key = "<leader>gd";
          mode = [ "n" ];
        }
        {
          action = "vim.lsp.buf.code_action";
          key = "<leader>ca";
          mode = [ "n" ];
        }
        {
          action = "$";
          key = "<leader>ll";
        }
        {
          action = "0";
          key = "<leader>hh";
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
      
        auto-save.enable = true;
        
        #autoclose.enable = true;
        nvim-autopairs.enable = true;

        neo-tree.enable = true;

        neotest = {
          enable = true;
          adapters = {
            phpunit.enable = true;
            python.enable = true;

        };
      };

        friendly-snippets.enable = true;

        efmls-configs = {
          enable = true;
          toolPackages = { 
            shellcheck = pkgs.shellcheck;
          }; 
        };

        none-ls = { 
          enable = true;
          sources = {
            formatting = {
              alejandra.enable = true;
              black.enable = true;
              clang_format.enable = true;
              shellharden.enable = true;
              sqlfluff.enable = true;
              yamlfmt.enable = true;
              isort.enable = true;
              terraform_fmt.enable = true;
            };

            diagnostics = {
              mypy.enable = true;
              pylint.enable = true;
              cppcheck.enable = true;
              zsh.enable = true;
            }; 
          };
        };

        cmp = {
          enable = true;
          autoEnableSources = true;
        };

        cmp-nvim-lsp.enable = true;
        cmp-nvim-lua.enable = true;
        cmp-rg.enable = true;
        cmp-treesitter.enable = true;
        cmp-zsh.enable = true;
        cmp-cmdline.enable = true;
        cmp-path.enable = true;
        cmp_luasnip.enable = true;

        comment.enable = true;

        lspkind.enable = true;

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

        dap = {
          enable = true;
          extensions = {
            dap-python.enable = true;
          };
        };

        lsp = {
          enable = true;

          servers = {
            phpactor.enable = true;
            tsserver.enable = true;
            dagger.enable = true;

            clangd.enable = true;

            dockerls.enable = true;

            bashls.enable = true;


            pylsp = {
              enable = true;
              settings = {
                plugins = {
                  flake8.enabled = true;
                  ruff.enabled = true;
                };
              };
            };
            terraformls.enable = true;
            nixd.enable = true;
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
          indent = true;
          folding = true;
        };
      };
    };
  };
}
