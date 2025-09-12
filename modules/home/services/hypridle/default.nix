{
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = osConfig.nixos.programs.hyprland;

  hypridleFlake = inputs.hypridle.packages.${pkgs.system}.hypridle;
  # hypridlePkg = pkgs.hypridle;
in
{
  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      package = hypridleFlake;
      settings = {
        general = {
          lock_cmd = "hyprlock";
          before_sleep_cmd = "$lock_cmd";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 900; # 15mins
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200; # 20mins
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
