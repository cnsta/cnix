{ lib
, config
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.devtools.neovim.plugins.barbar;
in
{
  options = {
    modules.devtools.neovim.plugins.barbar.enable = mkEnableOption "Enables Barbar plugin for Neovim";
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
