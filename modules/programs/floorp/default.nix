{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.floorp;
in
{
  options.cnix.programs.floorp.enable = mkEnableOption "Enables floorp browser";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.floorp ];
  };
}
