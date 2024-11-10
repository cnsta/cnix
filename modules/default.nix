{
  flake.nixosModules = {
    home = {
      imports = [
        ./home/programs/alacritty
        ./home/programs/anyrun
        ./home/programs/bash
        ./home/programs/chromium
        ./home/programs/discord
        ./home/programs/eza
        ./home/programs/firefox
        ./home/programs/foot
        ./home/programs/helix
        ./home/programs/hyprland
        ./home/programs/hyprlock
        ./home/programs/jujutsu
        ./home/programs/kitty
        ./home/programs/misc
        ./home/programs/mpv
        ./home/programs/neovim
        ./home/programs/rofi
        ./home/programs/ssh
        ./home/programs/thunar
        ./home/programs/tuirun
        ./home/programs/vscode
        ./home/programs/waybar
        ./home/programs/wezterm
        ./home/programs/yazi
        ./home/programs/zathura
        ./home/programs/zellij
        ./home/programs/zen
        ./home/programs/zsh

        ./home/services/blueman-applet
        ./home/services/copyq
        ./home/services/dconf
        ./home/services/gpg
        ./home/services/gtk
        ./home/services/hypridle
        ./home/services/hyprpaper
        ./home/services/mako
        ./home/services/polkit
        ./home/services/syncthing
        ./home/services/udiskie
        ./home/services/xdg
      ];
    };
    nixos = {
      imports = [
        ./nixos/boot/kernel
        ./nixos/boot/loader

        ./nixos/hardware/bluetooth
        ./nixos/hardware/graphics/amd
        ./nixos/hardware/graphics/nvidia
        ./nixos/hardware/logitech
        ./nixos/hardware/network

        ./nixos/programs/android
        ./nixos/programs/anyrun
        ./nixos/programs/beekeeper
        ./nixos/programs/blender
        ./nixos/programs/brightnessctl
        ./nixos/programs/corectrl
        ./nixos/programs/gamemode
        ./nixos/programs/gamescope
        ./nixos/programs/gimp
        ./nixos/programs/gnome
        ./nixos/programs/hyprland
        ./nixos/programs/inkscape
        ./nixos/programs/lutris
        ./nixos/programs/microfetch
        ./nixos/programs/misc
        ./nixos/programs/mysql-workbench
        ./nixos/programs/nh
        ./nixos/programs/npm
        ./nixos/programs/obsidian
        ./nixos/programs/steam
        ./nixos/programs/yubikey
        ./nixos/programs/zsh

        ./nixos/services/agenix
        ./nixos/services/blueman
        ./nixos/services/dbus
        ./nixos/services/dconf
        ./nixos/services/fwupd
        ./nixos/services/gnome-keyring
        ./nixos/services/greetd
        ./nixos/services/gvfs
        ./nixos/services/kanata
        ./nixos/services/locate
        ./nixos/services/mullvad
        ./nixos/services/nix-ld
        ./nixos/services/openssh
        ./nixos/services/pcscd
        ./nixos/services/pipewire
        ./nixos/services/powerd
        ./nixos/services/samba
        ./nixos/services/scx
        ./nixos/services/udisks
        ./nixos/services/xserver
        ./nixos/services/zram

        ./nixos/system/devpkgs
        ./nixos/system/fonts
        ./nixos/system/locale
        ./nixos/system/xdg
      ];
    };
    options = {
      imports = [
        ./options/monitors
      ];
    };
  };
}
