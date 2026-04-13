{
  nixpkgs = {
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
      permittedInsecurePackages = [
        "electron"
        "olm-3.2.16"
      ];
    };

    overlays = [
    ];
  };
}
