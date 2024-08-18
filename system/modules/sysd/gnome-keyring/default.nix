{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.gnome-keyring;
in {
  options = {
    modules.sysd.gnome-keyring.enable = mkEnableOption "Enables gnome-keyring";
  };
  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
  };
}
