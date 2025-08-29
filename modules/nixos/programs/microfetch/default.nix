{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.microfetch;
in
{
  options = {
    nixos.programs.microfetch.enable = mkEnableOption "Enables microfetch";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.microfetch ];
  };
}
