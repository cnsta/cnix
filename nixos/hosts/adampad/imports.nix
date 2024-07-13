{pkgs, ...}: {
  imports = [
    # core
    ../../core/adb.nix
    ../../core/fonts.nix
    ../../core/hyprland.nix
    ../../core/zsh.nix

    # hardware
    ../../hardware/adampad.nix

    # locale
    ../../locale/adampad.nix

    # services
    ../../services/blueman.nix
    ../../services/dbus.nix
    ../../services/gnome-keyring.nix
    ../../services/greetd.nix
    ../../services/gvfs.nix
    ../../services/mullvad.nix
    ../../services/openssh.nix
    ../../services/pipewire.nix
    ../../services/udisks.nix
    ../../services/xserver.nix
    ../../services/locate.nix
    ../../services/fwupd.nix

    # extra
    #../../extra/gaming.nix
    #../../extra/workstation
    # ../../extra/nix-ld
  ];

  environment = {
    systemPackages = with pkgs; [
      # Core
      fd
      git
      niv
      nix-output-monitor
      nvd
      sbctl

      # Util
      anyrun
      curl
      fzf
      gnome-disk-utility
      killall
      lazygit
      ntfs3g
      p7zip
      ripgrep
      stow
      tmux
      tmuxifier
      tree-sitter
      udiskie
      unrar
      unzip
      wget
      wlroots
      xdg-user-dirs
      xdg-utils

      # Dev
      binutils
      clang
      clang-tools
      cargo-edit
      cargo-insta
      cargo-nextest
      gcc
      gnumake
      cmake
      hyprlang
      python3
      python312Packages.httplib2
      python312Packages.oauth2
      gtk3
      gtk4
    ];
  };
}
