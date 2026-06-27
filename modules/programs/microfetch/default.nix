{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.microfetch;
in {
  options.cnix.programs.microfetch.enable = mkEnableOption "Enables microfetch";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.microfetch];
  };
}
