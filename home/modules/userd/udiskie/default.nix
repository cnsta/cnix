{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.userd.udiskie;
in {
  options = {
    modules.userd.udiskie.enable = mkEnableOption "Enables udiskie";
  };
  config = mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      tray = "always";
      notify = false;
    };
  };
}
