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
      common.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install common packages.";
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
          resources
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
        ]

        (mkIf cfg.common.enable [
          qt6.full
          swappy
          wayfreeze
          imagemagick
          wl-screenrec
          libqalculate
          fuzzel
          gnome-disk-utility
          networkmanagerapplet
          inotify-tools
          wf-recorder
          nautilus
        ])

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

        (mkIf cfg.server.enable [
          nvtopPackages.intel
          nvtopPackages.amd
          dig
          helix
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
