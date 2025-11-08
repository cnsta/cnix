{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.nixos.programs.hyprland;
  host = config.networking.hostName;

  commonExecOnce = [
    "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5"
    "uwsm app -- nm-applet --indicator"
  ];
in
{
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

    (mkIf (host == "kima") {
      programs.hyprland.settings.exec-once = [
        "uwsm app -- mullvad-vpn"
        "uwsm app -- solaar -w hide -b regular"
        "uwsm app -- blueman-applet"
      ]
      ++ commonExecOnce;
    })

    (mkIf (host == "bunk") {
      programs.hyprland.settings.exec-once = [
        "uwsm app -- blueman-applet"
      ]
      ++ commonExecOnce;
    })

    (mkIf (host == "toothpc") {
      programs.hyprland.settings.exec-once = [
        "uwsm app -- mullvad-vpn"
        "uwsm app -- solaar -w hide -b regular"
      ]
      ++ commonExecOnce;
    })
  ]);
}
