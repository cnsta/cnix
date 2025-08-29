{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.rofi;
in
{
  options = {
    home.programs.rofi.enable = mkEnableOption "Enables firefox";
  };
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = ./style.rasi;
      font = "Input Mono Narrow Light 12";
      extraConfig = {
        show-icons = true;
        drun-display-format = "{name}";
        disable-history = false;
        sidebar-mode = false;
      };
    };
  };
}
