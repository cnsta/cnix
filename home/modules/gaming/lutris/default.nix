{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.gaming.lutris;
in {
  options = {
    userModules.gaming.lutris.enable = mkEnableOption "Enables lutris";
  };
  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.lutris.override {
        extraPkgs = p: [
          p.wineWowPackages.staging
          p.pixman
          p.libjpeg
          p.gnome.zenity
        ];
      })
    ];
  };
}
