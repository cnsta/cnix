{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.inkscape;
in {
  options.cnix.programs.inkscape.enable = mkEnableOption "Enables inkscape";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inkscape-with-extensions
    ];
  };
}
