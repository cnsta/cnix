{
  inputs,
  outputs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
    };
  };

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/cnst/.nix-config";
    };
    dconf.enable = true;
  };

  security.rtkit.enable = true;

  environment.localBinInPath = true;

  console.useXkbConfig = true;
}
