{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.utils.anyrun;
in {
  options = {
    system.utils.anyrun.enable = mkEnableOption "Enables anyrun";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.anyrun
    ];
  };
}
