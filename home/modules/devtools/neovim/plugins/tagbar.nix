{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.neovim.plugins.tagbar;
in
{
  options = {
    modules.devtools.neovim.plugins.tagbar.enable = mkEnableOption "Enables Tagbar plugin for Neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.tagbar = {
        enable = true;
        settings.width = 50;
      };

      keymaps = [
        {
          mode = "n";
          key = "<C-g>";
          action = ":TagbarToggle<cr>";
          options.silent = true;
        }
      ];
    };
  };
}
