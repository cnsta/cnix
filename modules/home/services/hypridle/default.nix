# from fufexan
{
  osConfig,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
  lock = "${pkgs.systemd}/bin/loginctl lock-session";
  brillo = lib.getExe pkgs.brillo;
  timeout = 300;
  cfg = osConfig.nixos.programs.hyprland;
in
{
  config = mkIf cfg.enable {
    services.hypridle = {
      enable = false;
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
            on-timeout = lock;
          }
        ];
      };
    };
  };
}
