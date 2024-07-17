{
  pkgs,
  nixvim,
  systemType,
  ...
}:
nixvim.legacyPackages.${systemType}.makeNixvimWithModule {
  inherit pkgs;
  module = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    colorschemes.gruvbox.enable = true;

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

    keymaps = import ./resources/keymaps.nix;

    plugins = import ./resources/plugins {lib = pkgs.lib;};

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
  };
}
