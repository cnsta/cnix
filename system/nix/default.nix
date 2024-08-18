{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nixpkgs
    ./home-manager
    ./substituters
  ];

  environment = {
    systemPackages = with pkgs; [
      git
      scx
      stow
      winetricks
      protonup
    ];
    localBinInPath = true;
  };

  console.useXkbConfig = true;

  nix = {
    package = pkgs.lix;
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

      # # for direnv GC roots
      # keep-derivations = true;
      # keep-outputs = true;

      trusted-users = ["root" "@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 3 generations
      options = "--delete-older-than +3";
    };
  };
}
