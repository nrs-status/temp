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
        #alejandra #for formatting nix. disabled to check whether there are plugins already managing the format
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
        #recursive unfold in current foldable
        {
          action = "zczA";
          key = "zO";
          mode = ["n"];
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
        #currently not working, at least with ts and python
        {
          action = "<Cmd>vim.lsp.buf.type_definition()<cr>";
          key = "<leader>gy";
          mode = ["n"];
        }
        #currently not working, at least with ts and python

        {
          action = "<cmd>vim.lsp.buf.implementation()<cr>";
          key = "<leader>gi";
          mode = ["n"];
        }
        #currently not working, at least with ts and python

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
          mode = ["i" "n" "v"];
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

        #the following are config'd according to nvim-ufo recommendations
        foldcolumn = "0";
        foldlevel = 99;
        foldlevelstart = 99;
        foldenable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [nvim-surround];

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
                    ["p"] = ")",
                  },
                })

        function check_and_insert_space() -- function for <Tab> key
            -- Get the current cursor position
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))

            -- Get the current line
            local line = vim.api.nvim_get_current_line()

            -- Check if there's whitespace before the cursor
            local char_before_cursor = line:sub(col, col)
            if char_before_cursor:match("%s") or col == 0 then
                return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
            end
            local ls = require("luasnip")
            if ls.expand_or_jumpable() then
              return "<Plug>luasnip-expand-or-jump"
            end
            return vim.api.nvim_replace_termcodes("<Esc>la", true, false, true)
        end
        vim.keymap.set('i', '<Tab>', [[v:lua.check_and_insert_space()]], {expr = true, remap = true})
      '';
      plugins = {
        #find-next-character motion
        hop = {
          enable = true;
        };

        telescope = {
          enable = true;
          extensions.fzf-native.enable = true;
        };

        #colored brackets, parentheses, etc.
        rainbow-delimiters.enable = true;

        #automatic nix indentation, filetype detection for .nix files, syntax highlighting for nix
        nix.enable = true;

        #automatically set expandtab (enables spaces instead of tabs) and shiftwidth (amount of whitespace to add or remove when an indentation command is called) automatically
        sleuth.enable = true;

        #commands to add/remove/replace brackets, parenthesis, etc. in combination with motion commands
        surround.enable = false;

        auto-save.enable = true;

        #automatically close brackets, parentheses, etc.
        nvim-autopairs = {
          enable = true;
          settings = {
            map_cr = true; #behaviour of <cr> when cursor is in the following position: {|}
          };
        };

        #file browser
        neo-tree.enable = true;

        #unit testing
        neotest = {
          enable = true;
          adapters = {
            phpunit.enable = true;
            python.enable = true;
          };
        };

        #pre-existing snippets collection
        friendly-snippets.enable = true;

        #lsp improvements and prettification
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
            nix = ["alejandra"];
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
          enable = false;
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
        cmp-path.enable = true;
        cmp_luasnip.enable = true;

        #snippets engine
        luasnip = {
          enable = true;
          fromLua = [
            {paths = ./snippets;}
          ];
          fromSnipmate = [
            {}
            {paths = ./snippets;}
          ];
        };

        #bindings to automatically comment line/block
        comment.enable = true;

        #adds pictograms to lsp
        lspkind.enable = true;

        # git integrations
        gitsigns.enable = true;

        #add indentation guides
        indent-blankline = {
          enable = true;
          settings = {
            exclude = {
              buftypes = ["terminal" "nofile"];
              filetypes = ["help"];
            };
          };
        };

        #status line
        lualine.enable = true;

        #magit-like git interface
        neogit.enable = true;

        #debug adapter protocol client
        dap = {
          enable = true;
          extensions = {
            dap-python.enable = true;
          };
        };

        #lsp servers and keymaps related to them
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
            eslint.enable = true;
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

        #add context at the top of the window, wherever you are
        treesitter-context = {
          enable = false;
          settings = {
            max_lines = 5;
          };
        };

        #folding
        nvim-ufo = {
          enable = true;
          openFoldHlTimeout = 0;
          providerSelector = ''
            function()
              return { "lsp", "indent" }
            end
          '';
        };

        #automatically close html tags and rename them using treesitter
        ts-autotag = {
          enable = true;
        };
      };
    };
  };
}
