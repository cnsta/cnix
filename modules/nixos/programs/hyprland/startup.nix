{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.nixos.programs.hyprland;
  host = config.networking.hostName;

  commonExecOnce = [
    "pamixer --set-volume 50"
    "uwsm app -- blueman-applet"
    "uwsm app -- keepassxc"
    "uwsm app -- nm-applet --indicator"
  ];
in {
  options = {
    nixos.programs.hyprland.startup.enable = mkEnableOption "Enables startup settings in Hyprland";
  };

  config = mkIf cfg.startup.enable (mkMerge [
    {
      programs.hyprland.settings = {
        execr-once = [
          "uwsm finalize"
          "hyprlock"
        ];
      };
    }

    (mkIf (host == "cnixtop") {
      programs.hyprland.settings.exec-once =
        [
          "uwsm app -- mullvad-vpn"
          "uwsm app -- solaar -w hide -b regular"
        ]
        ++ commonExecOnce;
    })

    (mkIf (host == "cnixpad") {
      programs.hyprland.settings.exec-once =
        []
        ++ commonExecOnce;
    })

    (mkIf (host == "toothpc") {
      programs.hyprland.settings.exec-once =
        [
          "uwsm app -- mullvad-vpn"
          "uwsm app -- solaar -w hide -b regular"
        ]
        ++ commonExecOnce;
    })
  ]);
}
