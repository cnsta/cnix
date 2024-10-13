{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userModules.devtools.nixvim.plugins.barbar;
in {
  options = {
    userModules.devtools.nixvim.plugins.barbar.enable = mkEnableOption "Enables Barbar plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.barbar = {
      enable = true;
      keymaps = {
        next.key = "<TAB>";
        previous.key = "<S-TAB>";
        close.key = "<C-w>";
      };
    };
  };
}
