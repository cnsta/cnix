{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.nixos.programs.hyprland;
  host = config.networking.hostName;
in {
  options = {
    nixos.programs.hyprland.startup.enable = mkEnableOption "Enables startup settings in Hyprland";
  };

  config = mkIf cfg.startup.enable (mkMerge [
    {
      programs.hyprland.settings = {
        exec-once = [
          "sleep 2 && uwsm finalize"
          "hyprlock"
        ];
      };
    }

    (mkIf (host == "cnixtop") {
      programs.hyprland.settings.exec-once = [
        "uwsm app -- mullvad-vpn"
        "uwsm app -- blueman-applet"
        "uwsm app -- keepassxc"
        "uwsm app -- pamixer --set-volume 50"
        "uwsm app -- solaar -w hide -b regular"
        "uwsm app -- nm-applet --indicator"
      ];
    })

    (mkIf (host == "cnixpad") {
      programs.hyprland.settings.exec-once = [
        "uwsm app -- blueman-applet"
        "uwsm app -- keepassxc"
        "uwsm app -- pamixer --set-volume 50"
        "uwsm app -- nm-applet --indicator"
      ];
    })

    (mkIf (host == "toothpc") {
      programs.hyprland.settings.exec-once = [
        "uwsm app -- mullvad-vpn"
        "uwsm app -- keepassxc"
        "uwsm app -- solaar -w hide -b regular"
        "uwsm app -- nm-applet --indicator"
      ];
    })
  ]);
}
