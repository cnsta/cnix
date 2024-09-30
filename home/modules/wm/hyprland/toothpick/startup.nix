{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.wm.hyprland.toothpick.startup;
in {
  options = {
    modules.wm.hyprland.toothpick.startup.enable = mkEnableOption "Enables startup settings in Hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        # STARTUP
        # exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        "systemctl --user start polkit-gnome-authentication-agent-1"
        # exec-once = lxqt-policykit-agent &
        "mullvad-vpn"
        "pamixer --set-volume 50"
        # exec-once = swaybg -i ~/media/images/wallpaper.png
        "wl-clip-persist --clipboard regular --all-mime-type-regex '^(?!x-kde-passwordManagerHint).+'"
        # exec-once = hyprctl dispatch exec "sleep 4s && copyq --start-server"
        "hyprctl dispatch exec 'sleep 5s && keepassxc'"
        "hyprctl dispatch exec 'sleep 3s && solaar -w hide'"
      ];
    };
  };
}
