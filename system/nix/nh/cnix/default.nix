{
  environment.variables.FLAKE = "/home/cnst/.nix-config";
  programs = {
    nh = {
      enable = true;
      flake = "/home/cnst/.nix-config";
      # clean = {
      #   enable = true;
      #   extraArgs = "--keep-since 4d --keep 3";
      # };
    };
  };
}
