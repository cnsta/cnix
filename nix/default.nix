# Yanked from https://github.com/fufexan/dotfiles
{
  inputs,
  lib,
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./nixpkgs
    ./home-manager
    ./substituters
  ];

  age.secrets.accessTokens.file = "${self}/secrets/accessTokens.age";

  environment.localBinInPath = true;

  console = {
    keyMap = "sv-latin1";
    font = "LatGrkCyr-8x16";
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
      extraOptions = ''
        !include ${config.age.secrets.accessTokens.path}
      '';
    };
}
