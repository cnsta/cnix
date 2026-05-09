{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.ghostty;
in
{
  options.cnix.programs.ghostty.enable = mkEnableOption "Enables ghostty";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ghostty ];
  };
}
