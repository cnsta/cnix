{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.home.programs.hyprland;
  host = osConfig.networking.hostName;
in {
  options = {
    home.programs.hyprland.startup.enable = mkEnableOption "Enables startup settings in Hyprland";
  };

  config = mkIf cfg.startup.enable (mkMerge [
    {
      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "hyprlock"
          "systemctl --user start polkit-gnome-authentication-agent-1"
          "uwsm finalize"
          "uwsm app -- keepassxc'"
        ];
      };
    }

    (mkIf (host == "cnix") {
      wayland.windowManager.hyprland.settings.exec-once = [
        "uwsm app -- mullvad-vpn"
        "uwsm app -- blueman-applet"
        "uwsm app -- pamixer --set-volume 50"
        "uwsm app -- solaar -w hide"
      ];
    })

    (mkIf (host == "cnixpad") {
      wayland.windowManager.hyprland.settings.exec-once = [
        "blueman-applet"
        "pamixer --set-volume 50"
      ];
    })

    (mkIf (host == "toothpc") {
      wayland.windowManager.hyprland.settings.exec-once = [
        "mullvad-vpn"
        "hyprctl dispatch exec 'sleep 3s && solaar -w hide'"
      ];
    })
  ]);
}
