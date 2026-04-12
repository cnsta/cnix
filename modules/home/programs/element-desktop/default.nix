{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.element-desktop;
in
{
  options = {
    home.programs.element-desktop.enable = mkEnableOption "Enables Element Desktop";
  };
  config = mkIf cfg.enable {
    programs.element-desktop = {
      enable = true;
    };
  };
}
