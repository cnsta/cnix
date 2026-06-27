{
  config,
  lib,
  pkgs,
  bgs,
  inputs,
  clib,
  ...
}:
with lib; let
  cfg = config.cnix.services.hyprpaper;
  acct = config.cnix.settings.accounts;
  bg = config.cnix.settings.theme.background;

  monitorMappings = [
    {
      monitor = "DP-3";
      bg = bg.primary;
    }
    {
      monitor = "HDMI-A-1";
      bg = bg.secondary;
    }
    {
      monitor = "eDP-1";
      bg = bg.primary;
    }
    {
      monitor = "DVI-D-1";
      bg = bg.primary;
    }
  ];

  settings = {
    ipc = "on";
    splash = false;
    preload = bgs.all;
    wallpaper = bgs.resolveWallpaperBlocks monitorMappings;
  };
in {
  options.cnix.services.hyprpaper.enable = mkEnableOption "hyprpaper (Hyprland's wallpaper daemon)";

  config = mkIf cfg.enable {
    systemd.user.services.hyprpaper = {
      description = "Hyprland wallpaper daemon";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        Restart = "on-failure";
      };
    };

    hjem.users = genAttrs acct.defaultUsers (_: {
      packages = [
        pkgs.hyprpaper
        inputs.dotfiles.packages.${pkgs.stdenv.hostPlatform.system}.wppick
      ];
      xdg.config.files."hypr/hyprpaper.conf".text = clib.toHyprconf settings;
    });
  };
}
