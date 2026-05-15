{
  config,
  lib,
  clib,
  ...
}:
with lib;
let
  cfg = config.cnix.services.hypridle;
  acct = config.cnix.settings.accounts;

  lockTimeout = 300;
  dpmsTimeout = 360;

  hyprlock = getExe config.programs.hyprlock.package;

  settings = {
    general = {
      lock_cmd = "pgrep -x hyprlock || ${hyprlock}";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      ignore_systemd_inhibit = false;
    };
    listener = [
      {
        timeout = lockTimeout;
        on-timeout = "loginctl lock-session";
      }
      {
        timeout = dpmsTimeout;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
    ];
  };
in
{
  options.cnix.services.hypridle.enable = mkEnableOption "hypridle (Hyprland's idle daemon)";
  config = mkIf cfg.enable {
    services.hypridle.enable = true;
    hjem.users = genAttrs acct.defaultUsers (_: {
      xdg.config.files."hypr/hypridle.conf".text = clib.toHyprconf settings;
    });
  };
}
