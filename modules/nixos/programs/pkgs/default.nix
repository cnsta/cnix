{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkOption mkMerge types;
  cfg = config.nixos.programs.pkgs;
in {
  options = {
    nixos.programs.pkgs = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to install default core packages.";
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
      dev.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install development-specific packages.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      mkMerge [
        [
          ddcutil
          app2unit
          cava
          lm_sensors
          qt6.full
          swappy
          wayfreeze
          socat
          fuzzel
          imagemagick
          wl-screenrec
          jq
          fd
          libqalculate
          resources
          git
          stow
          tree
          traceroute
          gnome-disk-utility
          networkmanagerapplet
          progress
          wf-recorder
          inotify-tools
          git-crypt
          gparted
          ntfs3g
        ]

        (mkIf cfg.desktop.enable [
          protonup
          winetricks
          wine
          geekbench
          unigine-heaven
        ])

        (mkIf cfg.laptop.enable [
          brightnessctl
        ])

        (mkIf cfg.dev.enable [
          # lldb_20 # some biuld error atm
          gemini-cli
          nfs-utils
          gcc
          rust-analyzer
          lua-language-server
          nixd
          nil
          php
          vscode-langservers-extracted
          # phpactor
          python313Packages.python-lsp-server
          bash-language-server
          clang-tools
          marksman
          pyright

          # Formatters
          alejandra
          stylua
          nodejs_24
          fixjson
          sql-formatter
          nodePackages.prettier
          prettierd
          # php84Packages.php-cs-fixer
          shfmt
          luaformatter
          black
        ])
      ];
  };
}
