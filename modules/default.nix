{
  flake.nixosModules = {
    home = {
      imports = [
        ./home/browsers/chromium
        ./home/browsers/firefox
        ./home/browsers/zen

        ./home/comm/discord

        ./home/devtools/helix
        ./home/devtools/neovim
        ./home/devtools/vscode

        ./home/gaming/steam
        ./home/gaming/mangohud
        ./home/gaming/lutris

        ./home/cli/alacritty
        ./home/cli/bash
        ./home/cli/foot
        ./home/cli/jujutsu
        ./home/cli/kitty
        ./home/cli/wezterm
        ./home/cli/zellij
        ./home/cli/zsh

        ./home/userd/blueman-applet
        ./home/userd/copyq
        ./home/userd/dconf
        ./home/userd/gpg
        ./home/userd/gtk
        ./home/userd/mako
        ./home/userd/polkit
        ./home/userd/syncthing
        ./home/userd/udiskie
        ./home/userd/xdg

        ./home/utils/anyrun
        ./home/utils/eza
        ./home/utils/misc
        ./home/utils/mpv
        ./home/utils/rofi
        ./home/utils/ssh
        ./home/utils/tuirun
        ./home/utils/waybar
        ./home/utils/yazi
        ./home/utils/zathura

        ./home/wm/hyprland
        ./home/wm/utils/hypridle
        ./home/wm/utils/hyprlock
        ./home/wm/utils/hyprpaper
      ];
    };
    system = {
      imports = [
        ./system/boot/loader
        ./system/boot/kernel

        ./system/gaming/gamemode
        ./system/gaming/gamescope
        ./system/gaming/lutris
        ./system/gaming/steam

        ./system/gui/gnome
        ./system/gui/hyprland

        ./system/hardware/bluetooth
        ./system/hardware/graphics/amd
        ./system/hardware/graphics/nvidia
        ./system/hardware/logitech
        ./system/hardware/network

        ./system/studio/blender
        ./system/studio/gimp
        ./system/studio/inkscape
        ./system/studio/beekeeper
        ./system/studio/mysql-workbench

        ./system/sysd/network/blueman
        ./system/sysd/network/mullvad
        ./system/sysd/network/samba
        ./system/sysd/network/openssh

        ./system/sysd/security/agenix
        ./system/sysd/security/gnome-keyring

        ./system/sysd/session/dbus
        ./system/sysd/session/dconf
        ./system/sysd/session/xserver

        ./system/sysd/system/fwupd
        ./system/sysd/system/greetd
        ./system/sysd/system/gvfs
        ./system/sysd/system/locate
        ./system/sysd/system/nix-ld
        ./system/sysd/system/pcscd
        ./system/sysd/system/pipewire
        ./system/sysd/system/powerd
        ./system/sysd/system/udisks
        ./system/sysd/system/zram
        ./system/sysd/system/kanata

        ./system/utils/android
        ./system/utils/anyrun
        ./system/utils/brightnessctl
        ./system/utils/chaotic
        ./system/utils/corectrl
        ./system/utils/microfetch
        ./system/utils/misc
        ./system/utils/nh
        ./system/utils/npm
        ./system/utils/obsidian
        ./system/utils/yubikey
        ./system/utils/zsh
      ];
    };
    options = {
      imports = [
        ./options/monitors
      ];
    };
  };
}
