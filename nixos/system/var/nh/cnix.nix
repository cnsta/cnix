{
  environment.variables.FLAKE = "/home/cnst/.nix-config";
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/cnst/.nix-config";
    };
  };
}
