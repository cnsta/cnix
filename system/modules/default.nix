{systemModules, ...}: {
  imports = [
    "${systemModules}/gaming/gamemode"
    "${systemModules}/gaming/gamescope"
    "${systemModules}/gaming/lutris"
    "${systemModules}/gaming/steam"
    "${systemModules}/gui/gnome"
    "${systemModules}/gui/hyprland"
    "${systemModules}/hardware/bluetooth"
    "${systemModules}/hardware/graphics/amd"
    "${systemModules}/hardware/graphics/nvidia"
    "${systemModules}/hardware/logitech"
    "${systemModules}/hardware/network"
    "${systemModules}/studio/blender"
    "${systemModules}/studio/gimp"
    "${systemModules}/studio/inkscape"
    "${systemModules}/studio/beekeeper"
    "${systemModules}/studio/mysql-workbench"
    "${systemModules}/sysd/network/blueman"
    "${systemModules}/sysd/network/mullvad"
    "${systemModules}/sysd/network/samba"
    "${systemModules}/sysd/network/ssh"
    "${systemModules}/sysd/security/agenix"
    "${systemModules}/sysd/security/gnome-keyring"
    "${systemModules}/sysd/session/dbus"
    "${systemModules}/sysd/session/dconf"
    "${systemModules}/sysd/session/xserver/amd"
    "${systemModules}/sysd/session/xserver/amd/hhkbse"
    "${systemModules}/sysd/session/xserver/nvidia"
    "${systemModules}/sysd/system/fwupd"
    "${systemModules}/sysd/system/greetd"
    "${systemModules}/sysd/system/gvfs"
    "${systemModules}/sysd/system/locate"
    "${systemModules}/sysd/system/nix-ld"
    "${systemModules}/sysd/system/pcscd"
    "${systemModules}/sysd/system/pipewire"
    "${systemModules}/sysd/system/powerd"
    "${systemModules}/sysd/system/udisks"
    "${systemModules}/sysd/system/zram"
    "${systemModules}/utils/android"
    "${systemModules}/utils/anyrun"
    "${systemModules}/utils/brightnessctl"
    "${systemModules}/utils/corectrl"
    "${systemModules}/utils/microfetch"
    "${systemModules}/utils/misc"
    "${systemModules}/utils/npm"
    "${systemModules}/utils/yubikey"
  ];
}
