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
      # Skipping tests while upstream sorts it out, revert once
      # Hydra consistently builds openldap green.
      (final: prev: {
        openldap = prev.openldap.overrideAttrs (_: {
          doCheck = false;
        });
      })
    ];
  };
}
