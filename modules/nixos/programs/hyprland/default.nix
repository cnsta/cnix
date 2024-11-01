{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.hyprland;
  # hyprsysteminfoFlake = inputs.hyprsysteminfo.packages.${pkgs.system}.default;
in {
  options = {
    nixos.programs.hyprland = {
      enable = mkEnableOption "Enables hyprland";
    };
  };
  config = mkIf cfg.enable {
    security.pam.services.hyprlock.text = "auth include login";
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
    environment = {
      variables.NIXOS_OZONE_WL = "1";
      systemPackages = [
        # pkgs.hyprwayland-scanner
        # hyprsysteminfoFlake
      ];
    };
  };
}
