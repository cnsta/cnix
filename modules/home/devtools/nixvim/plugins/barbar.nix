{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.home.devtools.nixvim.plugins.barbar;
in {
  options = {
    home.devtools.nixvim.plugins.barbar.enable = mkEnableOption "Enables Barbar plugin for nixvim";
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
