{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.nixvim.plugins.barbar;
in {
  options = {
    modules.devtools.nixvim.plugins.barbar.enable = mkEnableOption "Enables Barbar plugin for nixvim";
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
