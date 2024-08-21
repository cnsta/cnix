{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.vimtex;
in {
  options = {
    modules.devtools.nixvim.plugins.vimtex.enable = mkEnableOption "Enables VimTeX plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.vimtex = {
        enable = true;
        settings = {
          view_method = "zathura";
          quickfix_enabled = true;
          quickfix_open_on_warning = false;
          quickfix_ignore_filters = [
            "Underfull"
            "Overfull"
            "specifier changed to"
            "Token not allowed in a PDF string"
          ];
          toc_config = {
            name = "TOC";
            layers = ["content" "todo"];
            resize = true;
            split_width = 50;
            todo_sorted = false;
            show_help = true;
            show_numbers = true;
            mode = 2;
          };
        };
      };

      files."after/ftplugin/tex.lua".keymaps = [
        {
          mode = "n";
          key = "m";
          action = ":VimtexView<cr>";
        }
      ];

      autoCmd = [
        {
          event = ["BufEnter" "BufWinEnter"];
          pattern = "*.tex";
          command = "set filetype=tex \"| VimtexTocOpen";
        }
        {
          event = "FileType";
          pattern = ["tex" "latex"];
          callback = ''
            function ()
              vim.o.foldmethod = 'expr'
              vim.o.foldexpr = 'vimtex#fold#level(v:lnum)'
              vim.o.foldtext = 'vimtex#fold#text()'
            end
          '';
        }
        {
          event = "User";
          pattern = "VimtexEventInitPost";
          callback = "vimtex#compiler#compile";
        }
        {
          event = "User";
          pattern = "VimtexEventQuit";
          command = "call vimtex#compiler#clean(0)";
        }
      ];
    };
  };
}
