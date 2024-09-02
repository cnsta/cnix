# Yanked from Misterio77's great config: https://github.com/Misterio77/nix-config
{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.devtools.neovim;
in {
  imports = [
    ./plugins
    ./lsp.nix
    ./syntaxes.nix
  ];
  options = {
    modules.devtools.neovim.enable = mkEnableOption "Enable neovim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      extraConfig =
        /*
        vim
        */
        ''
          "Use system clipboard
          set clipboard=unnamedplus
          "colorscheme
          colorscheme gruvbox-material

          set number

          "Lets us easily trigger completion from binds
          set wildcharm=<tab>

          "Folding
          set foldmethod=manual
          "Should be expr, but it's slow. So just use ':set fdm=expr' when it's needed.

          "Tabs
          set tabstop=4 "4 char-wide tab
          set expandtab "Use spaces
          set softtabstop=0 "Use same length as 'tabstop'
          set shiftwidth=0 "Use same length as 'tabstop'
          "2 char-wide overrides
          augroup two_space_tab
            autocmd!
            autocmd FileType json,html,htmldjango,hamlet,nix,scss,typescript,php,haskell,terraform setlocal tabstop=2
          augroup END

          "Set tera to use htmldjango syntax
          augroup tera_htmldjango
            autocmd!
            autocmd BufRead,BufNewFile *.tera setfiletype htmldjango
          augroup END

          "Options when composing mutt mail
          augroup mail_settings
            autocmd FileType mail set noautoindent wrapmargin=0 textwidth=0 linebreak wrap formatoptions +=w
          augroup END

          "Fix nvim size according to terminal
          "(https://github.com/neovim/neovim/issues/11330)
          augroup fix_size
            autocmd VimEnter * silent exec "!kill -s SIGWINCH" getpid()
          augroup END

          "Scroll up and down
          nmap <C-j> <C-e>
          nmap <C-k> <C-y>

          "Buffers
          nmap <space>b :buffers<CR>
             nmap <C-l> :bnext<CR>
          nmap <C-h> :bprev<CR>
          nmap <C-q> :bdel<CR>

          "Navigate
          nmap <space>e :e<space>
          nmap <space>e :e %:h<tab>
          "CD to current dir
          nmap <space>c :cd<space>
          nmap <space>C :cd %:h<tab>

          "Loclist
          nmap <space>l :lwindow<cr>
          nmap [l :lprev<cr>
          nmap ]l :lnext<cr>

          nmap <space>L :lhistory<cr>
          nmap [L :lolder<cr>
          nmap ]L :lnewer<cr>

          "Quickfix
          nmap <space>q :cwindow<cr>
          nmap [q :cprev<cr>
          nmap ]q :cnext<cr>

          nmap <space>Q :chistory<cr>
          nmap [Q :colder<cr>
          nmap ]Q :cnewer<cr>

          "Make
          nmap <space>m :make<cr>

          "Grep (replace with ripgrep)
          nmap <space>g :grep<space>
          if executable('rg')
              set grepprg=rg\ --vimgrep
              set grepformat=%f:%l:%c:%m
          endif

          "Close other splits
          nmap <space>o :only<cr>

          "Sudo save
          cmap w!! w !sudo tee > /dev/null %
        '';
      extraLuaConfig =
        /*
        lua
        */
        ''
          vim.g.have_nerd_font = true
          vim.wo.relativenumber = false
          vim.opt.cursorline = true

          vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
          vim.keymap.set("n", "<C-v>", "p", { desc = "Paste" })
          vim.keymap.set("i", "<C-v>", "<esc>p", { desc = "Paste" })
          vim.keymap.set("v", "<C-c>", "y", { desc = "Yank" })

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
          vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, { desc = "Code action" })

          -- Diagnostic
          vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
          vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { desc = "Diagnostics on loclist" })
          vim.keymap.set("n", "gq", vim.diagnostic.setqflist, { desc = "Diagnostics on quickfix" })

          function add_sign(name, text)
          	vim.fn.sign_define(name, { text = text, texthl = name, numhl = name })
          end

          add_sign("DiagnosticSignError", "󰅚 ")
          add_sign("DiagnosticSignWarn", " ")
          add_sign("DiagnosticSignHint", "󰌶 ")
          add_sign("DiagnosticSignInfo", " ")

          vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          -- When it releases
          -- vim.opt.foldexpr = "v:lua.vim.treesitter.foldtext()"

          -- Highlight when yanking (copying) text
          vim.api.nvim_create_autocmd("TextYankPost", {
          	desc = "Highlight when yanking (copying) text",
          	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
          	callback = function()
          		vim.highlight.on_yank()
          	end,
          })
        '';

      plugins = with pkgs.vimPlugins; [
        vim-table-mode
        editorconfig-nvim
        vim-surround
        gruvbox-material-nvim
        {
          plugin = nvim-autopairs;
          type = "lua";
          config =
            /*
            lua
            */
            ''
              require("nvim-autopairs").setup({})
            '';
        }
      ];
    };

    xdg.desktopEntries = {
      nvim = {
        name = "Neovim";
        genericName = "Text Editor";
        comment = "Edit text files";
        exec = "nvim %F";
        icon = "nvim";
        mimeType = [
          "text/english"
          "text/plain"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
        terminal = true;
        type = "Application";
        categories = [
          "Utility"
          "TextEditor"
        ];
      };
    };
  };
}
