{
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
