{
  environment.variables.FLAKE = "/home/adam/.nix-config";
  programs = {
    nh = {
      enable = true;
      flake = "/home/adam/.nix-config";
    };
  };
}
