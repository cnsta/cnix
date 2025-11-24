{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.nixos.programs.hyprland;
  host = config.networking.hostName;

  hmUser = builtins.head (builtins.attrNames config.home-manager.users);
  hmCfg = config.home-manager.users.${hmUser};
  swayncInstalled = hmCfg.home.services.swaync.enable;

  commonExecOnce = [
    "sleep 3s && wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5"
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

    (mkIf swayncInstalled {
      programs.hyprland.settings.exec-once = [
        "uwsm app -- swaync -c ~/.config/swaync/config.json"
      ];
    })

    (mkIf (host == "kima") {
      programs.hyprland.settings.exec-once = [
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
