# Yanked from https://github.com/fufexan/dotfiles
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  user = config.settings.accounts.username;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ifTheyExist [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "git"
      "mysql"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "kvm"
      "network"
      "gamemode"
      "adbusers"
      "users"
      "plocate"
      "fuse"
      "i2c"
      "wireshark"
      "fail2ban"
      "vaultwarden"
      "qbittorrent"
      "lidarr"
      "prowlarr"
      "bazarr"
      "sonarr"
      "radarr"
      "media"
      "share"
      "jellyfin"
      "render"
      "traefik"
      "immich"
      "pihole"
    ];
  };

  imports = [
    ./nixpkgs
    ./home-manager
    ./substituters
  ];

  environment.localBinInPath = true;

  console = {
    keyMap = "sv-latin1";
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
    in
    {
      package = pkgs.lix;
      # pin the registry to avoid downloading and evaling a new nixpkgs version every time
      registry = lib.mapAttrs (_: v: { flake = v; }) flakeInputs;

      # set the path for channels compat
      nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        warn-dirty = false;
        accept-flake-config = false;
        # allow-import-from-derivation = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "/etc/nix/registry.json";

        # # for direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        trusted-users = [
          "root"
          "@wheel"
        ];
      };
    };
}
