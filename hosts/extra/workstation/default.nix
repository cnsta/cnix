{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    blender
    gimp-with-plugins
    inkscape-with-extensions
  ];
}
