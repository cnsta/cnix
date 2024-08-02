{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./dconf
    ./fonts
    ./hyprland
    ./nixpkgs
    ./security
    ./home-manager
    ./substituters
    ./xdg
  ];

  environment = {
    systemPackages = [
      pkgs.git
      pkgs.scx
      pkgs.stow
    ];
    localBinInPath = true;
  };

  nix = {
    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      warn-dirty = false;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      trusted-users = ["root" "@wheel"];
    };
  };
}
