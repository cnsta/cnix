{systemModules, ...}: {
  imports = [
    "${systemModules}/network"
    "${systemModules}/gaming/gamemode"
    "${systemModules}/gaming/gamescope"
    "${systemModules}/gaming/steam"
    "${systemModules}/gaming/lutris"
    "${systemModules}/gui/gnome"
    "${systemModules}/gui/hyprland"
    "${systemModules}/utils/android"
    "${systemModules}/utils/anyrun"
    "${systemModules}/utils/corectrl"
    "${systemModules}/utils/microfetch"
    "${systemModules}/utils/nix-ld"
    "${systemModules}/sysd/blueman"
    "${systemModules}/sysd/dbus"
    "${systemModules}/sysd/fwupd"
    "${systemModules}/sysd/gnome-keyring"
    "${systemModules}/sysd/greetd"
    "${systemModules}/sysd/gvfs"
    "${systemModules}/sysd/locate"
    "${systemModules}/sysd/mullvad"
    "${systemModules}/sysd/pipewire"
    "${systemModules}/sysd/powerd"
    "${systemModules}/sysd/samba"
    "${systemModules}/sysd/sops"
    "${systemModules}/sysd/ssh"
    "${systemModules}/sysd/udisks"
    "${systemModules}/sysd/xserver/amd"
    "${systemModules}/sysd/xserver/amd/hhkbse"
    "${systemModules}/sysd/xserver/nvidia"
    "${systemModules}/hardware/graphics/amd"
    "${systemModules}/hardware/graphics/nvidia"
    "${systemModules}/hardware/bluetooth"
    "${systemModules}/hardware/logitech"
    "${systemModules}/studio/gimp"
    "${systemModules}/studio/inkscape"
    "${systemModules}/studio/blender"
  ];
}
