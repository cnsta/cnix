{
  nixpkgs = {
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
      permittedInsecurePackages = [
        "electron-38.8.4"
      ];
    };

    overlays = [
    ];
  };
}
