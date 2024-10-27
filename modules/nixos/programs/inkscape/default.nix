{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.inkscape;
in {
  options = {
    nixos.programs.inkscape.enable = mkEnableOption "Enables inkscape";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inkscape-with-extensions
    ];
  };
}
