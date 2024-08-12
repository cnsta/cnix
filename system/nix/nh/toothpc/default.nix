{
  environment.variables.FLAKE = "/home/toothpick/.nix-config";
  programs = {
    nh = {
      enable = true;
      flake = "/home/toothpick/.nix-config";
    };
  };
}
