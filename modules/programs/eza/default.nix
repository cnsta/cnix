{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.eza;
in
{
  options.cnix.programs.eza.enable = mkEnableOption "Enables eza";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.eza ];
  };
}
