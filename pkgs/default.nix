{
  systems = ["x86_64-linux"];

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor {};
      wl-ocr = pkgs.callPackage ./wl-ocr {};
    };
  };
}
