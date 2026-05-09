{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cnix.services.tailray;
in
{
  imports = [ inputs.tailray.nixosModules.default ];

  options.cnix.services.tailray.enable = mkEnableOption "tailray";

  config = mkIf cfg.enable {
    services.tailray.enable = true;

    systemd.user.services.tailray = {
      environment.TAILRAY_THEME = "dark";

      after = mkForce [
        "graphical-session.target"
        "quickshell.service"
        "waybar.service"
      ];
      wants = [
        "quickshell.service"
        "waybar.service"
      ];
    };
  };
}
