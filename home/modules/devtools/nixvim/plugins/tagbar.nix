{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userModules.devtools.nixvim.plugins.tagbar;
in {
  options = {
    userModules.devtools.nixvim.plugins.tagbar.enable = mkEnableOption "Enables Tagbar plugin for nixvim";
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
