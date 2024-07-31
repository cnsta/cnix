let
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
}
