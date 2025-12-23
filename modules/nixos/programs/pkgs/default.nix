{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkMerge
    types
    ;
  cfg = config.nixos.programs.pkgs;
in
{
  options = {
    nixos.programs.pkgs = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to install default core packages.";
      };
      gui.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install gui-specific packages.";
      };
      desktop.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install desktop-specific packages.";
      };
      laptop.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install laptop-specific packages.";
      };
      server.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install server-specific packages.";
      };
      dev.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install development-specific packages.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      mkMerge [
        [
          pciutils
          wireguard-tools
          ddcutil
          app2unit
          cava
          lm_sensors
          socat
          jq
          fd
          git
          stow
          tree
          traceroute
          progress
          git-crypt
          gparted
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
        ]

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
          cosmic-files
        ])

        (mkIf cfg.desktop.enable [
          geekbench
          obs-studio
        ])

        (mkIf cfg.laptop.enable [
          brightnessctl
        ])

        (mkIf cfg.server.enable [
          nvtopPackages.intel
          zfstools
        ])

        (mkIf cfg.dev.enable [
          sqlite
          nfs-utils
          gcc
          rust-analyzer
          lua-language-server
          nixd
          nil
          php
          phpactor
          vscode-langservers-extracted
          nodePackages.typescript-language-server
          python313Packages.python-lsp-server
          bash-language-server
          clang-tools
          marksman
          pyright
          fish-lsp
          nodejs_25

          # Formatters
          nixfmt
          rustfmt
          deno
          stylua
          fixjson
          sql-formatter
          nodePackages.prettier
          prettierd
          shfmt
          black
        ])
      ];
  };
}
