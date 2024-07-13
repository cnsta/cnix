{
  inputs,
  outputs,
  ...
}: {
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/adam/.nix-config";
    };
  };
  security.rtkit.enable = true;

  environment.localBinInPath = true;

  console.useXkbConfig = true;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
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
