{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.anyrun;
in {
  options = {
    cnix.programs.anyrun.enable = mkEnableOption "Enables anyrun";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.anyrun
    ];
  };
}
