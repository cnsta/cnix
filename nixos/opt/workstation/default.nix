{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gimp-with-plugins
    inkscape-with-extensions
  ];
}
