{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.anyrun;
in {
  options = {
    modules.utils.anyrun.enable = mkEnableOption "Enables anyrun";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.anyrun
    ];
  };
}
