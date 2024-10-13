{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.studio.inkscape;
in {
  options = {
    systemModules.studio.inkscape.enable = mkEnableOption "Enables inkscape";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inkscape-with-extensions
    ];
  };
}
