{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.studio.inkscape;
in {
  options = {
    nixos.studio.inkscape.enable = mkEnableOption "Enables inkscape";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inkscape-with-extensions
    ];
  };
}
