{
  config,
  lib,
  pkgs,
  clib,
  ...
}:
with lib;
let
  cfg = config.cnix.services.hypridle;
  acct = config.cnix.settings.accounts;

  timeout = 300;
  brillo = getExe pkgs.brillo;

  settings = {
    general = {
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      lock_cmd = "pgrep hyprlock || ${getExe config.programs.hyprlock.package}";
    };
    listener = [
      {
        timeout = timeout - 10;
        on-timeout = "${brillo} -O; ${brillo} -u 500000 -S 10";
        on-resume = "${brillo} -I -u 250000";
      }
      {
        inherit timeout;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = timeout + 10;
        on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
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
