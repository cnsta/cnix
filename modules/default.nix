{
  flake.nixosModules = {
    home = {
      imports = [
        ./home/programs/aerc
        ./home/programs/alacritty
        ./home/programs/bash
        ./home/programs/chromium
        ./home/programs/discord
        ./home/programs/eza
        ./home/programs/floorp
        ./home/programs/firefox
        ./home/programs/fish
        ./home/programs/foot
        ./home/programs/fuzzel
        ./home/programs/ghostty
        ./home/programs/git
        ./home/programs/helix
        ./home/programs/hyprlock
        ./home/programs/jujutsu
        ./home/programs/kitty
        ./home/programs/mpv
        ./home/programs/neovim
        ./home/programs/nvf
        ./home/programs/nwg-bar
        ./home/programs/pkgs
        ./home/programs/rofi
        ./home/programs/ssh
        ./home/programs/tuirun
        ./home/programs/vscode
        ./home/programs/waybar
        ./home/programs/wezterm
        ./home/programs/yazi
        ./home/programs/zathura
        ./home/programs/zed-editor
        ./home/programs/zellij
        ./home/programs/zen
        ./home/programs/zsh

        ./home/services/blueman-applet
        ./home/services/copyq
        ./home/services/dconf
        ./home/services/dunst
        ./home/services/gpg
        ./home/services/gtk
        ./home/services/hypridle
        ./home/services/hyprpaper
        ./home/services/mako
        ./home/services/nix-index
        ./home/services/protonmail-bridge
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
        ./nixos/hardware/graphics
        ./nixos/hardware/logitech
        ./nixos/hardware/network

        ./nixos/programs/android
        ./nixos/programs/beekeeper
        ./nixos/programs/blender
        ./nixos/programs/corectrl
        ./nixos/programs/fish
        ./nixos/programs/gamemode
        ./nixos/programs/gamescope
        ./nixos/programs/gimp
        ./nixos/programs/gnome
        ./nixos/programs/hyprland
        ./nixos/programs/inkscape
        ./nixos/programs/lact
        ./nixos/programs/lutris
        ./nixos/programs/microfetch
        ./nixos/programs/pkgs
        ./nixos/programs/mysql-workbench
        ./nixos/programs/nh
        ./nixos/programs/npm
        ./nixos/programs/obsidian
        ./nixos/programs/steam
        ./nixos/programs/thunar
        ./nixos/programs/yubikey
        ./nixos/programs/zsh

        ./nixos/services/agenix
        ./nixos/services/blueman
        ./nixos/services/dbus
        ./nixos/services/dconf
        ./nixos/services/flatpak
        ./nixos/services/fwupd
        ./nixos/services/gnome-keyring
        ./nixos/services/greetd
        ./nixos/services/gvfs
        ./nixos/services/kanata
        ./nixos/services/locate
        ./nixos/services/mullvad
        ./nixos/services/nfs
        ./nixos/services/nix-ld
        ./nixos/services/openssh
        ./nixos/services/pcscd
        ./nixos/services/pipewire
        ./nixos/services/polkit
        ./nixos/services/powerd
        ./nixos/services/psd
        ./nixos/services/samba
        ./nixos/services/scx
        ./nixos/services/udisks
        ./nixos/services/xserver
        ./nixos/services/zram

        ./nixos/system/fonts
        ./nixos/system/locale
        ./nixos/system/xdg
      ];
    };
    server = {
      imports = [
        ./server
        ./server/caddy
        ./server/fail2ban
        ./server/homepage-dashboard
        ./server/vaultwarden
        ./server/bazarr
        ./server/prowlarr
        ./server/lidarr
        ./server/radarr
        ./server/sonarr
        ./server/jellyseerr
        ./server/jellyfin
        ./server/podman
        ./server/unbound
        ./server/uptime-kuma
      ];
    };
    settings = {
      imports = [
        ./settings/accounts
        ./settings/monitors
        ./settings/theme
      ];
    };
  };
}
