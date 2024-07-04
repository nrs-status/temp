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
        #shift subs
        {
          action = "<cmd>call feedkeys(\"{\", \"nt\")<cr>";
          key = "[[";
          mode = ["i"];
        }
        {
          action = "}";
          key = "]]";
          mode = ["i"];
        }
        {
          action = "(";
          key = "99";
          mode = ["i"];
        }
        #fine-grained undo
        {
          action = "<c-g>u,";
          key = ",";
          mode = ["i"];
        }
        {
          action = "<c-g>u;";
          key = ";";
          mode = ["i"];
        }
        {
          action = "<c-g>u<bs>";
          key = "<bs>";
          mode = ["i"];
        }
        {
          action = "<c-g>u<cr>";
          key = "<cr>";
          mode = ["i"];
        }
        {
          action = "<c-g>u<spc>";
          key = "<spc>";
          mode = ["i"];
        }
        {
          action = ":noh<CR><Esc>"; #unselect search match
          key = "<Esc>";
        }
        {
          action = ":q<cr>";
          key = "<Leader>qq";
        }
        {
          action = "<Esc>ja";
          key = "jj";
          mode = ["i"];
        }
        {
          action = "<Esc>ka";
          key = "kk";
          mode = ["i"];
        }
        {
          action = "<Esc>]]";
          key = "<leader>]]";
        }
        {
          action = "<Esc>]}";
          key = "<leader>]}";
          mode = ["i"];
        }
        {
          action = "<Esc> ])";
          key = "<leader>])";
        }
        {
          action = "<Esc>:q<cr>";
          key = "<leader>qq";
          mode = ["i"];
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
          action = "<Esc>l";
          key = "jk";
          mode = ["i"];
        }
        {
          action = "<Esc>";
          key = "kj";
          mode = ["i"];
        }
        {
          action = "<Cmd>Neotree toggle<CR>";
          key = "<leader>n";
        }
        {
          action = "<Cmd>lua vim.lsp.buf.hover()<cr>";
          key = "<leader>gk";
          mode = ["n"];
          options.remap = true;
        }
        {
          action = "<Cmd>lua vim.lsp.buf.definition()<cr>";
          key = "<leader>gd";
          mode = ["n"];
        }
        {
          action = "<Cmd>vim.lsp.buf.type_definition()<cr>";
          key = "<leader>gy";
          mode = ["n"];
        }
        {
          action = "<cmd>vim.lsp.buf.implementation()<cr>";
          key = "<leader>gi";
          mode = ["n"];
        }
        {
          action = "<cmd>vim.lsp.buf.code_action()<cr>";
          key = "<leader>ca";
          mode = ["n"];
        }
        {
          action = "$";
          key = "<leader>ll";
          mode = ["n" "i"];
        }
        {
          action = "0";
          key = "<leader>hh";
          mode = ["n" "i"];
        }
        {
          key = "f"; #used to activate the hop plugin
          action.__raw = ''
            function()
              require'hop'.hint_char1({
                direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
                current_line_only = false
              })
            end
          '';
          options.remap = true;
        }
        {
          key = "<C-f>";
          action.__raw = ''
            function ()
              return "/" .. vim.fn.getcharstr() .. "<cr><cmd>nohl<cr>"
            end
          '';
          options.expr = true; #makes it such that what is evaluated is the return value of the entire expression
          mode = ["i" "n"];
        }
        {
          key = "F";
          action.__raw = ''
            function()
              require'hop'.hint_char1({
                direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
                current_line_only = false
              })
            end
          '';
          options.remap = true;
        }
      ];

      opts = {
        number = true; # Show line numbers
        relativenumber = true; # Show relative line numbers

        mouse = "a"; # Enable mouse control
        mousemodel = "extend"; # Mouse right-click extends the current selection

        shiftwidth = 4;
        tabstop = 4;

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
      extraConfigLua = ''
        local set= function(name) -- defines a function called 'set' that will automatically configure packages such that set "package" is equivalent to require('package').setup()
          local ok, p = pcall(require, name) -- assigns the return value of pcall(require, name) to ok, p
          if ok then
            p.setup()
          end
        end

        require'nvim-surround'.setup({
          aliases = {
            ["c"] = "}",
          },
        })
      '';
      extraPlugins = with pkgs.vimPlugins; [nvim-surround];
      plugins = {
        hop = {
          #find-next-character motion
          enable = true;
        };
        telescope = {
          enable = true;
          extensions.fzf-native.enable = true;
        };
        rainbow-delimiters.enable = true;
        nix.enable = true;
        sleuth.enable = true;
        surround.enable = false;

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

        lspsaga.enable = true;
        lsp-format.enable = false; #disabled while testing conform-nvim
        conform-nvim = {
          enable = true;
          formattersByFt = {
            haskell = ["ormolu"];
            javascript = ["prettierd"];
            javascriptreact = ["prettierd"];
            typescript = ["prettierd"];
            typescriptreact = ["prettierd"];
            python = ["black"];
            lua = ["stylua"];
            markdown = ["prettierd"];
          };
          formatOnSave = {
            lspFallback = true;
            timeoutMs = 2000;
          };
        };
        none-ls = {
          enable = true;
          enableLspFormat = false; #disabled while testing conform-nvim
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

        #cmp stands for completion; these are completion plugins
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            mapping = {
              __raw = ''
                cmp.mapping.preset.insert({
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-c>'] = cmp.mapping.abort(),

                ['<C-b>'] = cmp.mapping.scroll_docs(-4),

                 ['<C-w>'] = cmp.mapping.scroll_docs(4),

                 ['<C-Space>'] = cmp.mapping.complete(),

                 ['<CR>'] = cmp.mapping.confirm({ select = true }),

                 ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                })
              '';
            };
            sources = [
              {
                name = "nvim_lsp";
              }
              {
                name = "luasnip";
              }
              {
                name = "path";
              }
              {
                name = "nvim_lua";
              }
              {
                name = "treesitter";
              }
              {
                name = "zsh";
              }
              {
                name = "cmdline";
              }
              {
                name = "kitty";
              }
              {
                name = "ctags";
              }
              {
                name = "sql";
              }
            ];
          };
        };

        cmp-nvim-lsp.enable = true;
        cmp-nvim-lua.enable = true;
        cmp-rg.enable = true;
        cmp-treesitter.enable = true;
        cmp-zsh.enable = true;
        #cmp-cmdline.enable = true;
        cmp-path.enable = true;
        cmp_luasnip.enable = true;

        comment.enable = true;

        lspkind.enable = true; #adds pictograms to lsp

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

          keymaps = {
            diagnostic = {
              "<leader>cd" = {
                action = "open_float";
                desc = "Line Diagnostics";
              };
              "<leader>j" = {
                action = "goto_next";
                desc = "Next Diagnostic";
              };
              "<leader>k" = {
                action = "goto_prev";
                desc = "Previous Diagnostic";
              };
            };
          };

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
            hls = {
              enable = true;
            };
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
        };
      };
    };
  };
}
