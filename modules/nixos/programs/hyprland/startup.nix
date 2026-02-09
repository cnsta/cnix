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
    "sleep 3s && wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5"
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
      ]
      ++ commonExecOnce;
    })

    (mkIf (host == "bunk") {
      programs.hyprland.settings.exec-once = [
      ]
      ++ commonExecOnce;
    })

    (mkIf (host == "toothpc") {
      programs.hyprland.settings.exec-once = [
        "uwsm-app -s b -- solaar -w hide -b regular"
      ]
      ++ commonExecOnce;
    })
  ]);
}
