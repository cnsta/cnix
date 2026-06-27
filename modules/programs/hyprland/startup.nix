{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.cnix.programs.hyprland;
  host = config.networking.hostName;

  baseStartup = [
    "uwsm finalize"
    "hyprlock"
    "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "gnome-keyring-daemon --start --components=secrets"
    "ashell"
    "sleep 3s && wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5"
  ];
in {
  options.cnix.programs.hyprland.startup.enable =
    mkEnableOption "Enables startup settings in Hyprland";
  config = mkIf cfg.startup.enable (mkMerge [
    {cnix.programs.hyprland.lua.startup = baseStartup;}

    (mkIf (host == "toothpc") {
      cnix.programs.hyprland.lua.startup = [
        "uwsm-app -s b -- solaar -w hide -b regular"
      ];
    })
  ]);
}
