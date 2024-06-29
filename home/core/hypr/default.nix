{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [../../extra/mako];

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

  home.sessionVariables = {
    BROWSER = "firefox";
    NIXOS_OZONE_WL = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    extraConfig = ''
      ${builtins.readFile ./hyprland.conf}
    '';
    systemd = {
      enable = true;
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}
