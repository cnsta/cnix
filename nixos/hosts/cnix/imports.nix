{pkgs, ...}: {
  imports = [
    # core
    ../../core/hyprland.nix
    ../../core/adb.nix
    ../../core/zsh.nix
    ../../core/fonts.nix

    # hardware
    ../../hardware/cnix.nix

    # locale
    ../../locale/cnix.nix

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

    # extra
    ../../extra/gaming.nix
    ../../extra/workstation
    # ../../extra/nix-ld
  ];

  environment = {
    systemPackages = with pkgs; [
      # Core
      git
      sbctl
      niv
      nix-output-monitor
      nvd
      fd

      # Util
      stow
      wget
      curl
      ripgrep
      python3
      hyprlang
      python312Packages.oauth2
      python312Packages.httplib2
      killall
      tree-sitter
      lazygit
      tmux
      tmuxifier
      unzip
      p7zip
      unrar
      xdg-utils
      xdg-user-dirs
      ntfs3g
      gnome-disk-utility
      wlroots
      fzf
      udiskie
    ];
  };
}
