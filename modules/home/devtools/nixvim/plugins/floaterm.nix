{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.home.devtools.nixvim.plugins.floaterm;
in {
  options = {
    home.devtools.nixvim.plugins.floaterm.enable = mkEnableOption "Enables Floaterm plugin for nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.floaterm = {
      enable = true;
      width = 0.8;
      height = 0.8;
      title = "";

      keymaps.toggle = "<leader>,";
    };
  };
}
