{
  pkgs,
  config,
  lib,
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
        ])

        (mkIf cfg.laptop.enable [
          brightnessctl
        ])

        (mkIf cfg.dev.enable [
          lldb_19
          nfs-utils
          gcc
          rust-analyzer
          lua-language-server
          nixd
          nil
          php
          vscode-langservers-extracted
          # phpactor
          python312Packages.python-lsp-server
          bash-language-server
          clang-tools
          marksman
          pyright

          # Formatters
          alejandra
          stylua
          nodePackages_latest.nodejs
          nodePackages_latest.fixjson
          nodePackages_latest.sql-formatter
          prettierd
          # php84Packages.php-cs-fixer
          shfmt
          luaformatter
          black
        ])
      ];
  };
}
