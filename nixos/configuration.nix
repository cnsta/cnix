# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users = {
      # Import your home-manager configuration
      cnst = import ../home-manager/home.nix;
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        warn-dirty = false;
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # System packages
  environment = {
    systemPackages = [
      # Dev
      pkgs.git
      pkgs.pyright
      pkgs.python3
      pkgs.gcc
      pkgs.go
      pkgs.nodePackages_latest.npm
      pkgs.nodePackages_latest.nodejs
      pkgs.nodePackages.prettier
      pkgs.nodePackages.prettier-plugin-toml
      pkgs.lua-language-server
      pkgs.stylua
      pkgs.prettierd
      pkgs.cargo
      pkgs.hyprlang
      pkgs.nixd
      pkgs.nil
      pkgs.black
      pkgs.python312Packages.jedi-language-server
      pkgs.isort
      pkgs.bacon
      pkgs.clang
      pkgs.clang-tools
      pkgs.alejandra

      # Util
      pkgs.stow
      pkgs.gnumake
      pkgs.wget
      pkgs.curl
      pkgs.ripgrep
      pkgs.python312Packages.oauth2
      pkgs.python312Packages.httplib2
      pkgs.python312Packages.pip
      pkgs.killall
      pkgs.tree-sitter
      pkgs.lazygit
      pkgs.tmux
      pkgs.tmuxifier
      pkgs.unzip
      pkgs.p7zip
      pkgs.unrar
    ];
    localBinInPath = true;
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code-symbols
    font-awesome
    jetbrains-mono
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
        "Iosevka"
        "3270"
        "DroidSansMono"
      ];
    })
  ]; # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "cnix";
  };
  # Enable sound with pipewire.
  hardware = {
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libva
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  zramSwap.enable = true;

  security.rtkit.enable = true;

  programs = {
    solaar.enable = true;
    nix-ld.enable = true;
    adb.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/cnst/.nix-config";
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    zsh.enable = true;
  };
  # Time zone & Locale
  time.timeZone = "Europe/Stockholm";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };

  # Console keymap
  console.useXkbConfig = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    cnst = {
      isNormalUser = true;
      shell = pkgs.zsh;
      # openssh.authorizedKeys.keys = [];
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
      ];
    };
  };

  # services
  services = {
    blueman.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "cnst";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --remember-session";
          user = "greeter";
        };
      };
    };
    openssh = {
      enable = true;
      settings = {
        # Opinionated: forbid root login through SSH.
        PermitRootLogin = "no";
        # Opinionated: use keys only.
        # Remove if you want to SSH using passwords
        PasswordAuthentication = false;
      };
    };
    xserver = {
      enable = true;
      #  displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        extraLayouts.hhkbse = {
          description = "HHKBse by cnst";
          languages = [ "se" ];
          symbolsFile = /home/cnst/.nix-config/nixos/xkb/symbols/hhkbse;
        };
        layout = "hhkbse";
        # dir = "/home/cnst/.nix-config/nixos/xkb";
        variant = "";
        options = "lv3:rwin_switch";
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
