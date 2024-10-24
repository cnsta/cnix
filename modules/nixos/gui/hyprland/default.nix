{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.gui.hyprland;
in {
  options = {
    nixos.gui.hyprland.enable = mkEnableOption "Enables hyprland";
  };
  config = mkIf cfg.enable {
    security.pam.services.hyprlock.text = "auth include login";
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    environment.variables.NIXOS_OZONE_WL = "1";
  };
}
