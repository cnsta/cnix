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
          "uwsm finalize"
          "hyprlock"
        ];
      };
    }

    (mkIf (host == "cnix") {
      wayland.windowManager.hyprland.settings.exec-once = [
        "uwsm app -- mullvad-vpn"
        "uwsm app -- blueman-applet"
        "uwsm app -- keepassxc"
        "uwsm app -- pamixer --set-volume 50"
        "uwsm app -- solaar -w hide -b regular"
        "uwsm app -- nm-applet --indicator"
      ];
    })

    (mkIf (host == "cnixpad") {
      wayland.windowManager.hyprland.settings.exec-once = [
        "uwsm app -- blueman-applet"
        "uwsm app -- keepassxc"
        "uwsm app -- pamixer --set-volume 50"
        "uwsm app -- nm-applet --indicator"
      ];
    })

    (mkIf (host == "toothpc") {
      wayland.windowManager.hyprland.settings.exec-once = [
        "uwsm app -- mullvad-vpn"
        "uwsm app -- keepassxc"
        "uwsm app -- solaar -w hide -b regular"
        "uwsm app -- nm-applet --indicator"
      ];
    })
  ]);
}
