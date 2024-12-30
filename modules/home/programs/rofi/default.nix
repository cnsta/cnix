{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.rofi;
in {
  options = {
    home.programs.rofi.enable = mkEnableOption "Enables firefox";
  };
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        font = "Input Mono Narrow Light 12";
        show-icons = true;
        drun-display-format = "{name}";
        disable-history = false;
        sidebar-mode = false;
      };
      theme = ./style.rasi;
    };
  };
}
