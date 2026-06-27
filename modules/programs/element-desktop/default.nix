{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.programs.element-desktop;
in {
  options.cnix.programs.element-desktop.enable = mkEnableOption "Enables Element Desktop";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.element-desktop];
  };
}
