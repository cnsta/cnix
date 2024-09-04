{
  environment.variables.FLAKE = "/home/cnst/.nix-config";
  programs = {
    nh = {
      enable = true;
      flake = "/home/cnst/.nix-config";
    };
  };
}
