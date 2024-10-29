{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.hyprland.startup;
  isCnix = osConfig.networking.hostName == "cnix";
  isCnixpad = osConfig.networking.hostName == "cnixpad";
  isToothpc = osConfig.networking.hostName == "toothpc";
in {
  options = {
    home.programs.hyprland.startup.enable = mkEnableOption "Enables startup settings in Hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once =
        [
          "systemctl --user start polkit-gnome-authentication-agent-1"
          "udiskie -Nt"
          "wl-clip-persist --clipboard regular --all-mime-type-regex '^(?!x-kde-passwordManagerHint).+'"
          "hyprctl dispatch exec 'sleep 5s && keepassxc'"
        ]
        ++ lib.optionals isCnix [
          "mullvad-vpn"
          "blueman-applet"
          "pamixer --set-volume 50"
          "hyprctl dispatch exec 'sleep 3s && solaar -w hide'"
        ]
        ++ lib.optionals isCnixpad [
          "blueman-applet"
        ]
        ++ lib.optionals isToothpc [
          "mullvad-vpn"
          "hyprctl dispatch exec 'sleep 3s && solaar -w hide'"
        ];
    };
  };
}
