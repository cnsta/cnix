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

  home.packages = with pkgs; [
    grimblast
    slurp
    hyprpicker
    swaybg
    tofi
    gnome.gnome-calculator
  ];
}
