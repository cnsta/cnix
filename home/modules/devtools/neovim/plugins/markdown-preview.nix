{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.neovim.plugins.markdown-preview;
in
{
  options = {
    modules.devtools.neovim.plugins.markdown-preview.enable = mkEnableOption "Enables Markdown Preview plugin for Neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.markdown-preview = {
        enable = true;

        settings = {
          auto_close = false;
          theme = "dark";
        };
      };

      files."after/ftplugin/markdown.lua".keymaps = [
        {
          mode = "n";
          key = "<leader>m";
          action = ":MarkdownPreview<cr>";
        }
      ];
    };
  };
}
