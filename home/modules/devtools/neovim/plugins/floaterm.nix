{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.neovim.plugins.floaterm;
in
{
  options = {
    modules.devtools.neovim.plugins.floaterm.enable = mkEnableOption "Enables Floaterm plugin for Neovim";
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
