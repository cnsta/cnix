{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.studio.inkscape;
in {
  options = {
    modules.studio.inkscape.enable = mkEnableOption "Enables inkscape";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inkscape-with-extensions
    ];
  };
}
