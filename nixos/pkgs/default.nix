{
  systems = ["x86_64-linux"];

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      wl-ocr = pkgs.callPackage ./wl-ocr {};
    };
  };
}
