{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.wm.utils.hypridle;

  hypridleFlake = inputs.hypridle.packages.${pkgs.system}.hypridle;
  # hypridlePkg = pkgs.hypridle;
in {
  options = {
    userModules.wm.utils.hypridle.enable = mkEnableOption "Enables hypridle";
  };
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
