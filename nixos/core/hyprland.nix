{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];
  environment.variables.NIXOS_OZONE_WL = "1";
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = lib.mkForce ["hyprland" "kde"];
    extraPortals = [pkgs.xdg-desktop-portal-kde];
  };
}
