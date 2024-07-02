{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../extra/mako
    ./rofi.nix
  ];

  xdg.portal = let
    hyprland = config.wayland.windowManager.hyprland.package;
    xdph = pkgs.xdg-desktop-portal-hyprland.override {inherit hyprland;};
  in {
    extraPortals = [xdph];
    configPackages = [hyprland];
  };
  home.packages = with pkgs; [
    grimblast
    slurp
    hyprpicker
    swaybg
    tofi
    gnome.gnome-calculator
  ];
  wayland.windowManager.hyprland = {
  };
}
