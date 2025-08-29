# Yanked from https://github.com/fufexan/dotfiles
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./nixpkgs
    ./home-manager
    ./substituters
  ];

  environment.localBinInPath = true;

  console.useXkbConfig = true;

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
