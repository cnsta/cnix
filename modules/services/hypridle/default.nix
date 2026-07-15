{
  config,
  lib,
  clib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.services.hypridle;
  acct = config.cnix.settings.accounts;

  lock = "${pkgs.systemd}/bin/loginctl lock-session";
  wlopm = pkgs.wlopm;
  timeout = 300;

  hyprlock = getExe config.programs.hyprlock.package;

  settings = {
    general = {
      lock_cmd = "pgrep -x hyprlock || ${hyprlock}";
      before_sleep_cmd = lock;
      after_sleep_cmd = "${wlopm} --on";
      ignore_dbus_inhibit = false;
      ignore_systemd_inhibit = false;
    };
    listener = [
      {
        timeout = timeout;
        on-timeout = lock;
      }
      {
        timeout = timeout + 20;
        on-timeout = "${wlopm} --off";
        on-resume = "${wlopm} --on";
      }
    ];
  };
in {
  options.cnix.services.hypridle.enable = mkEnableOption "hypridle (Hyprland's idle daemon)";
  config = mkIf cfg.enable {
    services.hypridle.enable = true;
    hjem.users = genAttrs acct.defaultUsers (_: {
      files.".config/hypr/hypridle.conf" = {
        text = clib.toHyprconf settings;
        clobber = true;
      };
    });
  };
}
