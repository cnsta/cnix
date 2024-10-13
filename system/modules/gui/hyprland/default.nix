{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.gui.hyprland;
in {
  options = {
    systemModules.gui.hyprland.enable = mkEnableOption "Enables hyprland";
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    environment.variables.NIXOS_OZONE_WL = "1";
  };
}
