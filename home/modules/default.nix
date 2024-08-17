{userModules, ...}: {
  imports = [
    "${userModules}/wm/hyprland"
    "${userModules}/wm/utils/hypridle"
    "${userModules}/wm/utils/hyprlock"
    "${userModules}/wm/utils/hyprpaper"

    "${userModules}/browsers/firefox"
    "${userModules}/browsers/chromium"

    "${userModules}/comm/discord"

    "${userModules}/gaming/lutris"
    "${userModules}/gaming/mangohud"
    # "${userModules}/create"
    "${userModules}/devtools/neovim"
    "${userModules}/devtools/vscode"
    # "${userModules}/media"
    "${userModules}/terminal/alacritty"
    "${userModules}/terminal/foot"
    "${userModules}/terminal/kitty"
    "${userModules}/terminal/zellij"
    "${userModules}/userd/sops"
    "${userModules}/userd/copyq"
    "${userModules}/userd/mako"
    "${userModules}/userd/udiskie"
    # "${userModules}/userd"
    "${userModules}/utils/ags"
    "${userModules}/utils/anyrun"
    "${userModules}/utils/rofi"
    "${userModules}/utils/waybar"
    "${userModules}/utils/yazi"
    "${userModules}/utils/misc"
    # "${userModules}/wm"
  ];
}
