{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  homeDir = builtins.getEnv "HOME";
in {
  environment.variables.FLAKE = "${homeDir}/.nix-config";
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${homeDir}/.nix-config";
    };
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

  security = {
    rtkit.enable = true;
    pam.services.hyprlock = {};
  };

  environment.localBinInPath = true;

  console.useXkbConfig = true;

  nixpkgs = {
    overlays = [
      (_: prev: {
        python312 = prev.python312.override {packageOverrides = _: pysuper: {nose = pysuper.pynose;};};
      })
    ];
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
    };
  };
}
