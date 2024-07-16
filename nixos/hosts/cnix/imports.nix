{pkgs, ...}: {
  imports = [
    # core
    ../../core/fonts.nix
    ../../core/hyprland.nix
    ../../core/zsh.nix

    # hardware
    ../../hardware/cnix.nix

    # locale
    ../../locale

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

    # extra
    ../../extra/gaming.nix
    ../../extra/android
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
      rocmPackages.rocm-smi

      # Util
      anyrun
      curl
      fzf
      gnome-disk-utility
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
      python3
      python312Packages.httplib2
      python312Packages.oauth2
      gtk3
      gtk4

      # misc.language_servers
      typescript-language-server
      typescript
      nixd
      nil
      statix
      hyprlang
      alejandra
      nixpkgs-fmt
      pyright
      isort
      rustfmt
      rust-analyzer
      clippy
      lua-language-server
      stylua
      nodePackages_latest.nodejs
      nodePackages.prettier
      prettierd
      black
      vimPlugins.nvim-treesitter-parsers.typescript

      # ags_dependencies
      bash
      coreutils
      dart-sass
      gawk
      imagemagick
      procps
      util-linux
      gnome.gnome-control-center
      mission-center
      overskride
      wlogout
    ];
  };
}
