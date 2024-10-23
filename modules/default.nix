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
    nixos = {
      imports = [
        ./nixos/boot/loader
        ./nixos/boot/kernel

        ./nixos/gaming/gamemode
        ./nixos/gaming/gamescope
        ./nixos/gaming/lutris
        ./nixos/gaming/steam

        ./nixos/gui/gnome
        ./nixos/gui/hyprland

        ./nixos/hardware/bluetooth
        ./nixos/hardware/graphics/amd
        ./nixos/hardware/graphics/nvidia
        ./nixos/hardware/logitech
        ./nixos/hardware/network

        ./nixos/studio/blender
        ./nixos/studio/gimp
        ./nixos/studio/inkscape
        ./nixos/studio/beekeeper
        ./nixos/studio/mysql-workbench

        ./nixos/services/network/blueman
        ./nixos/services/network/mullvad
        ./nixos/services/network/samba
        ./nixos/services/network/openssh

        ./nixos/services/security/agenix
        ./nixos/services/security/gnome-keyring

        ./nixos/services/session/dbus
        ./nixos/services/session/dconf
        ./nixos/services/session/xserver

        ./nixos/services/system/fwupd
        ./nixos/services/system/greetd
        ./nixos/services/system/gvfs
        ./nixos/services/system/locate
        ./nixos/services/system/nix-ld
        ./nixos/services/system/pcscd
        ./nixos/services/system/pipewire
        ./nixos/services/system/powerd
        ./nixos/services/system/udisks
        ./nixos/services/system/zram
        ./nixos/services/system/kanata

        ./nixos/system/locale

        ./nixos/utils/android
        ./nixos/utils/anyrun
        ./nixos/utils/brightnessctl
        ./nixos/utils/chaotic
        ./nixos/utils/corectrl
        ./nixos/utils/microfetch
        ./nixos/utils/misc
        ./nixos/utils/nh
        ./nixos/utils/npm
        ./nixos/utils/obsidian
        ./nixos/utils/yubikey
        ./nixos/utils/zsh
      ];
    };
    options = {
      imports = [
        ./options/monitors
      ];
    };
  };
}
