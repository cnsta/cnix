{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge;
  cfg = config.system.utils.misc;
in {
  options = {
    system.utils.misc = {
      enable = mkEnableOption "Enables miscellaneous packages";
      desktop.enable = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to install desktop-specific packages.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = mkMerge [
      [
        pkgs.nodejs_22
        pkgs.tree
      ]
      (mkIf cfg.desktop.enable [
        pkgs.protonup
        pkgs.winetricks
      ])
    ];
  };
}
