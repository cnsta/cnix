{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userModules.devtools.nixvim.plugins.markdown-preview;
in {
  options = {
    userModules.devtools.nixvim.plugins.markdown-preview.enable = mkEnableOption "Enables Markdown Preview plugin for nixvim";
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
