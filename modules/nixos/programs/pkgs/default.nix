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
          gnome-disk-utility
          networkmanagerapplet
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
          nfs-utils
          gcc
          rust-analyzer
          lua-language-server
          nixd
          nil
          php
          # php84Packages.php-cs-fixer
          # phpactor
          python312Packages.python-lsp-server
          bash-language-server
          clang-tools
          marksman
          pyright
          # nodePackages_latest.intelephense

          # Formatters
          alejandra
          stylua
          nodePackages_latest.fixjson
          nodePackages_latest.sql-formatter
          prettierd
          shfmt
          luaformatter
          black
        ])
      ];
  };
}
