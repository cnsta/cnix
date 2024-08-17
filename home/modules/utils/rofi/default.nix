{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.rofi;
in {
  options = {
    modules.utils.rofi.enable = mkEnableOption "Enables firefox";
  };
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland-unwrapped;
      configPath = "home/cnst/.config/rofi/config.rasi";
      font = "Rec Mono Linear 11";
    };
  };
}
