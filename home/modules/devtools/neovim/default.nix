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
    ./keybindings.nix
  ];

  options = {
    modules.devtools.neovim.enable = mkEnableOption "Enable neovim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      extraLuaConfig =
        /*
        lua
        */
        ''
          -- Use system clipboard
          vim.opt.clipboard = "unnamedplus"

          -- Colorscheme
          vim.cmd("colorscheme gruvbox-material")

          -- Line Numbers and Cursorline
          vim.opt.number = true
          vim.opt.cursorline = true
          vim.wo.relativenumber = false

          -- Nerd Font
          vim.g.have_nerd_font = true

          -- Enable persistent undo
          vim.opt.undofile = true
          vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")

          -- Set wildcharm to tab for triggering completion
          vim.opt.wildcharm = vim.fn.char2nr(vim.api.nvim_replace_termcodes("<Tab>", true, true, true))

          -- Folding
          vim.opt.foldmethod = "manual"
          vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          -- vim.opt.foldexpr = "v:lua.vim.treesitter.foldtext()"

          -- Tabs
          vim.opt.tabstop = 4
          vim.opt.expandtab = true
          vim.opt.softtabstop = 0
          vim.opt.shiftwidth = 0

          -- 2 char-wide overrides for specific file types
          vim.api.nvim_create_augroup("two_space_tab", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
          	pattern = { "json", "html", "htmldjango", "hamlet", "nix", "scss", "typescript", "php", "haskell", "terraform" },
          	command = "setlocal tabstop=2",
          	group = "two_space_tab",
          })

          -- Set tera to use htmldjango syntax
          vim.api.nvim_create_augroup("tera_htmldjango", { clear = true })
          vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
          	pattern = "*.tera",
          	command = "setfiletype htmldjango",
          	group = "tera_htmldjango",
          })

          -- Options when composing mutt mail
          vim.api.nvim_create_augroup("mail_settings", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
          	pattern = "mail",
          	command = "set noautoindent wrapmargin=0 textwidth=0 linebreak wrap formatoptions+=w",
          	group = "mail_settings",
          })

          -- Fix nvim size according to terminal
          vim.api.nvim_create_augroup("fix_size", { clear = true })
          vim.api.nvim_create_autocmd("VimEnter", {
          	pattern = "*",
          	command = "silent exec '!kill -s SIGWINCH' getpid()",
          	group = "fix_size",
          })

          -- Highlight when yanking (copying) text
          vim.api.nvim_create_autocmd("TextYankPost", {
          	desc = "Highlight when yanking (copying) text",
          	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
          	callback = function()
          		vim.highlight.on_yank()
          	end,
          })

          -- Diagnostic signs
          function add_sign(name, text)
          	vim.fn.sign_define(name, { text = text, texthl = name, numhl = name })
          end

          add_sign("DiagnosticSignError", "󰅚 ")
          add_sign("DiagnosticSignWarn", " ")
          add_sign("DiagnosticSignHint", "󰌶 ")
          add_sign("DiagnosticSignInfo", " ")
        
'';

      plugins = with pkgs.vimPlugins; [
        vim-table-mode
        editorconfig-nvim
        vim-surround
        gruvbox-material-nvim
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
