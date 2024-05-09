{ config, lib, pkgs, ... }:

let cfg = config.nineveh.home.neovim;
in {
  options.nineveh.home.neovim.enable = lib.mkEnableOption "Neovim";

  config = lib.mkIf cfg.enable {

    home = { sessionVariables.EDITOR = "nvim";
    packages = with pkgs; [
      alejandra #for formatting nix
        ];
};
    pam.sessionVariables.EDITOR = "nvim";


    programs.neovim =
      let
          meta.homepage = "https://github.com/ShinKage/idris2-nvim/commits/main";
      in
      {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        extraPackages = with pkgs; [ fd ripgrep wl-clipboard xclip ];
        plugins = with pkgs.vimPlugins; [
          {
            plugin = gitsigns-nvim;
            type = "lua";
            config = ''
              require('gitsigns').setup {
                signs = {
                  add = { hl = 'GitGutterAdd', text = '+' },
                  change = { hl = 'GitGutterChange', text = '~' },
                  delete = { hl = 'GitGutterDelete', text = '_' },
                  topdelete = { hl = 'GitGutterDelete', text = '‾' },
                  changedelete = { hl = 'GitGutterChange', text = '≁' },
                },
              }
            '';
          }
          {
            plugin = gruvbox-nvim;
            config = ''
              colorscheme gruvbox
              set background=dark
              set termguicolors
            '';
          }
          julia-vim
          {
            plugin = lexima-vim;
            config = ''
              let g:lexima_enable_basic_rules = 0
              let g:lexima_enable_endwise_rules = 0
            '';
          }
          {
            plugin = indent-blankline-nvim;
            config = ''
              let g:indent_blankline_char_list=['┃', '╏', '┇', '┋', '│', '¦', '┆', '┊']
              let g:indent_blankline_filetype_exclude=['help']
              let g:indent_blankline_buftype_exclude=['terminal', 'nofile']
            '';
          }
          {
            plugin = lualine-nvim;
            type = "lua";
            config = "require('lualine').setup()";
          }
          nui-nvim # required by idris2-nvim
          {
            plugin = nvim-colorizer-lua;
            type = "lua";
            config = "require('colorizer').setup()";
          }
          {
            plugin = neogit;
            config = ''
              lua require('neogit').setup()
            '';
          }
          # nvim-web-devicons
          luasnip
          plenary-nvim
          {
            plugin = telescope-nvim;
            config = ''
              nnoremap <leader><SPACE> <cmd>Telescope git_files<cr>
              nnoremap <leader>pf <cmd>Telescope git_files<cr>
              nnoremap <leader>/ <cmd>Telescope live_grep<cr>
              nnoremap <leader>bb <cmd>Telescope buffers<cr>
              nnoremap <leader>: <cmd>Telescope commands<cr>
              nnoremap <leader>: <cmd>Telescope commands<cr>
              nnoremap <leader>iy <cmd>Telescope registers<cr>
              nnoremap <leader>ss <cmd>Telescope current_buffer_fuzzy_find<cr>
              nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
            '';
          }
          {
            plugin = telescope-fzf-native-nvim;
            type = "lua";
            config = ''
              require('telescope').load_extension 'fzf'
            '';
          }
          {
            plugin = vim-eunuch;
            config = ''
              nnoremap <leader>fd :Delete<cr>
              nnoremap <leader>fr :Rename<cr>
            '';
          }
          vim-lion
          vim-nix
          vim-repeat
          vim-sleuth
          vim-sneak
          vim-surround
          vim-toml
        ];
      };
  };
}

