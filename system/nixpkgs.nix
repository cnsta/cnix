{inputs, ...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        input-fonts.acceptLicense = true;
        permittedInsecurePackages = ["olm-3.2.16"];
      };
      overlays = [
        inputs.emacs-overlay.overlays.default
      ];
    };
  };
}
