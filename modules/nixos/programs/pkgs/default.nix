{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.nixos.programs.pkgs;
in
{
  options.nixos.programs.pkgs = {
    common.enable = mkEnableOption "core packages";
    desktop.enable = mkEnableOption "desktop-specific packages";
    gui.enable = mkEnableOption "gui-specific packages";
    laptop.enable = mkEnableOption "laptop-specific packages";
    server.enable = mkEnableOption "server-specific packages";
    dev = {
      common.enable = mkEnableOption "generic development packages";
      rust.enable = mkEnableOption "rust-specific packages";
      php.enable = mkEnableOption "php-specific packages";
      python.enable = mkEnableOption "python-specific packages";
    };
  };

  config.environment.systemPackages =
    with pkgs;
    mkMerge [
      (mkIf cfg.common.enable [
        pciutils
        wireguard-tools
        parted
        ddcutil
        app2unit
        cava
        lm_sensors
        socat
        jq
        fd
        stow
        tree
        traceroute
        progress
        git-crypt
        ntfs3g
        cloudflared
        libargon2
        openssl
        xmrig
        ocl-icd
        dig
        unzip
        zip
        gnutar
        gnused
        p7zip
        ripgrep
        file
        libnotify
        unrar
        libqalculate
        nixd
        nil
        nixfmt
      ])
      (mkIf cfg.gui.enable [
        resources
        swappy
        wayfreeze
        imagemagick
        gnome-disk-utility
        networkmanagerapplet
        networkmanager_dmenu
        inotify-tools
        wf-recorder
        nautilus
        kdePackages.qt6ct
        libsForQt5.qt5ct
        brightnessctl
        gparted
      ])
      (mkIf cfg.desktop.enable [
        geekbench
        obs-studio
      ])
      (mkIf cfg.laptop.enable [
      ])
      (mkIf cfg.server.enable [
        nvtopPackages.intel
        zfstools
      ])
      (mkIf cfg.dev.common.enable [
        sqlite
        nfs-utils
        gcc
        lua-language-server
        vscode-langservers-extracted
        bash-language-server
        clang-tools
        marksman
        fish-lsp
        nodejs_25
        kdePackages.qtdeclarative
        pkg-config
        deno
        stylua
        fixjson
        sql-formatter
        prettierd
        shfmt
        black
        nufmt
        nu-lint
      ])
      (mkIf cfg.dev.rust.enable [
        (inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.complete.withComponents [
          "cargo"
          "clippy"
          "llvm-tools"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        rust-analyzer
      ])
      (mkIf cfg.dev.php.enable [
        php
        phpactor
      ])
      (mkIf cfg.dev.python.enable [
        pyright
        python313Packages.python-lsp-server
        python3
        python3Packages.pyusb
        python3Packages.pygobject3
      ])
    ];
}
