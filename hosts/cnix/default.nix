{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.cnst = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [];
    extraGroups = ifTheyExist [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "git"
      "mysql"
      "docker"
      "libvirtd"
      "network"
    ];
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../pkgs/cnix.nix
    ../pkgs/fonts.nix
    ../programs
    ../services/cnix.nix
    ../hardware/cnix.nix
    ../generic/cnix.nix
    ./hardware-configuration.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users = {
      cnst = import ../../home/cnst/home.nix;
    };
  };

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        auto-optimise-store = lib.mkDefault true;
        warn-dirty = false;
        # Enable flakes and new 'nix' command
        experimental-features = [
          "nix-command"
          "flakes"
        ];
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

  # Add .local/bin to $PATH
  environment.localBinInPath = true;

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "cnix";
  };

  # Garbage collector / Nix helper
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/cnst/.nix-config";
    };
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  console.useXkbConfig = true;
  # services

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
